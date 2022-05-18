require 'exceptions'

class Gsp::EwayBillAuthenticatedApi 
  include HTTParty
  debug_output $stdout
  default_options.update(verify: false)
  default_options.update(verify_peer: false)



  attr_accessor :app_key, :auth_token, :sek, :gstin, :username, :password, :client_id, :client_secret, :ewb_user_id

  attr_accessor :encrypted_sek, :decrypted_sek, :eway_bill_model, :session_random_key, :rek, :environment, :endpoint

  def initialize
    @gstn_crypto = GstnCrypto.new
    self.ewb_user_id = environment == :production ? ENV['EWAY_EWB_USER_ID'] : ENV['STAGING_EWAY_USER_ID']
  end

  def update_eway_user_info(eway_user)
    self.auth_token = eway_user.auth_token
    self.encrypted_sek = eway_user.auth_encrypted_sek
    self.app_key = Base64.strict_decode64(eway_user.app_key)
    self.decrypted_sek = Base64.strict_decode64(eway_user.auth_decrypted_sek)
    self.environment = eway_user.ewaybill&.eway_environment.present? ?  eway_user.ewaybill&.eway_environment&.to_sym : :staging
    self.endpoint = eway_user.ewaybill.endpoint_name.present? ? eway_user.ewaybill.endpoint_name.constantize : nil
  end

  # response =  {status: "1", authtoken: "WnCyOc4GCPnxWaVLxzbCUu0mK", sek: "S/bVUheRj2BMUrmZunyoXl59SyUUgQNVONDZ7tp2oKEI4nFfgyu9XzCb/Wd7bkbM"}                              
  def get_auth_token(username, password)
    self.session_random_key = SecureRandom.hex(16)
    is_sandbox = true
    if self.environment == :production
      is_sandbox = false
    end
    encrypted_app_key =  @gstn_crypto.encrypted_app_key_eway(session_random_key, is_sandbox: is_sandbox)
    self.app_key = encrypted_app_key
    auth_response = eway_request("/authenticate/", 
                 {
                   app_key: self.app_key,
                   username: username,
                   password: @gstn_crypto.encrypted_app_key_eway(password, is_sandbox: is_sandbox)
                 },
                 action: 'ACCESSTOKEN')
    update_eway_auth_token(auth_response) if auth_response['status'] == '1'
    auth_response
  end

  def is_success(response)
    response[:success] && response[:body]["status"] != "0"
  end

  def eway_request(path, body = {}, options = {})
    endpoint_manager = Gsp::Eway::Endpoints::EndpointManager.new(environment)
    base_url_setter = proc { |url| self.base_url = url }
    request_maker = proc { |headers, endpoint|
      existing_headers = options[:headers] || {}
      new_options = options.dup
      new_options[:headers] = existing_headers.merge headers
      _eway_request(path, body, new_options)
    }
    Rails.logger.info "Making request using endpoint #{endpoint}"
    if endpoint.present?
      endpoint_manager.make_request_with_endpoint(endpoint, self, base_url_setter, request_maker)
    else
      endpoint_manager.make_request(self, base_url_setter, request_maker)
    end
  end


  def _eway_request(path, body, options)
    begin
      method = options[:method] || 'post'
      body = body.to_hash
      new_body = {}
      error_data = ""
      action = options[:action]
      headers = options[:headers] || {}
      headers = headers.merge!('Content-Type' => 'application/json') \
                        .merge!(base_headers)
      if method != 'get' && action != 'ACCESSTOKEN'
        new_body[:action] = action
        # self.decrypted_sek = @gstn_crypto.decrypt_data_without_encode(self.encrypted_sek, "b3ecb60efb7145bfb87e077c27e7c207")
        new_body[:data] = @gstn_crypto.encrypt_data_eway(body[:data].to_json, decrypted_sek)
      end
      if action == 'ACCESSTOKEN'
        headers.merge!({'ewb-user-id' => self.ewb_user_id, 'gstin' => self.gstin})
        new_body = {}
        new_body = body.merge!({action: action})
      else
        headers.merge!('authtoken' => self.auth_token)  
      end
      audit_object = audit_request(action, headers, path)
      new_body = new_body.to_json
      response = self.class.send(method,
                                path,
                                headers: headers,
                                body: new_body)
      parsed_response = response.parsed_response      
      if parsed_response["error_code"].present?
        raise ::EwayBillUpstreamException.new(parsed_response, response)
      end
      if action == "ACCESSTOKEN" && parsed_response["status"] == '1'
        final_response = parsed_response
      elsif parsed_response['Message'] == "An error has occurred."
        raise ::EwayBillUpstreamException.new(parsed_response, response)
      elsif !parsed_response['data'].nil? && parsed_response['status'] == '1' && method == 'get'
        self.rek = @gstn_crypto.decrypt_data_without_encode(parsed_response['rek'], self.decrypted_sek)
        final_response = @gstn_crypto.decrypt_data_without_encode(parsed_response['data'], self.rek)
      elsif method == 'post' && parsed_response['status'] == '1'
        puts "#############{parsed_response}#################"
        final_response = @gstn_crypto.decrypt_data_without_encode(parsed_response['data'], self.decrypted_sek)
      else 
        if parsed_response['status'] == '0'
          error_info = ""
          final_response = Base64.strict_decode64(parsed_response['error']) if parsed_response['error'].present?
          puts "####### Error Response: ######"
          puts "#############{parsed_response}#################"
          if parsed_response['info'].present?
            if parsed_response['info'].include?(" ")
              error_info = parsed_response['info']
              error_data = final_response + error_info
            else
              error_info_decoded = Base64.strict_decode64(parsed_response['info'])
              begin 
                error_info = JSON.parse(error_info_decoded)
              rescue => e
                puts "################Rescued from: #################{e}################"
                error_info = error_info_decoded
              end
              error_data = error_info
            end
          end
          parse_final_response = JSON.parse(final_response)
          puts "##################Error Info###########################"
          puts "###################{error_info}########################"
          parse_final_response['info'] = error_info if parsed_response['info'].present?
          if parse_final_response['errorCodes'] == "238"
            unset_auth_token
          end
          final_response = parse_final_response
        else
          raise ::EwayBillUpstreamException.new(response)
        end
      end 
      audit_resposne(parsed_response, audit_object, error_data)
      final_response
    rescue Net::ReadTimeout, Errno::ECONNREFUSED => error
      raise ::EwayBillUpstreamException.new(error, response)
    rescue OpenSSL::Cipher::CipherError => error
      error_data = "Bad Decryption token please reauthenticate again."
      audit_resposne({}, audit_object, error_data)
      raise ::SslDecryptionError.new(error_data, response)
    end
  end

  def base_url=(url)
    @base_url = url
    self.class.base_uri(url)
  end

  # TODO EWAY BILL APIS LOGS 
  def audit_request(action, headers, path)
    audit_request = EwayApiLog.create(
      requested_at: DateTime.now,
      gstin: self.gstin,
      request_headers: headers,
      api_name: action,
      eway_bill_user: eway_bill_model.ewaybill,
      base_url: self.class.base_uri + path,
    )
    audit_request
  end

  def audit_resposne(response, audit_object, error_data = "")
    audit_object.response_at = DateTime.now
    audit_object.response_type = response['status'] == '1' ? 'Valid' : 'Invalid'
    audit_object.invalid_reason = response['errorCodes']
    if(response['status'] != '1')
      audit_object.invalid_reason = error_data
    end
    audit_object.save!
  end

  def base_headers
    {
    }
  end

  private

  def unset_auth_token
    eway_bill_model.unset_auth_token
    eway_bill_model.save!
  end

  def update_eway_auth_token(body)
    self.auth_token = body['authtoken']
    self.encrypted_sek = body['sek']
    self.decrypted_sek = @gstn_crypto.decrypt_data_without_encode(self.encrypted_sek, self.session_random_key)
    Rails.logger.info "Authentication Data #{auth_token} #{encrypted_sek} #{decrypted_sek}"


    eway_bill_model.update_auth_token(self, body)
    eway_bill_model.save!
  end

end