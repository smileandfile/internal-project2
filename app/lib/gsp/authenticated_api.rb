require 'exceptions'

class Gsp::AuthenticatedApi < Gsp::BaseApi

  attr_accessor :username, :gstin, :user_ip, :state_code, :domain_name, :current_user_email
  attr_accessor :auth_token, :expires_at, :encrypted_sek, :session_encryption_key
  attr_accessor :app_key, :gstin_model, :token_expires_at
  
  URL = '/taxpayerapi/v0.2/authenticate'.freeze

  MAX_TRIES = 3

  def initialize()
    super()
    self.username = 'Shalibhadra.MH.1'
  end

  # TODO CHECK THIS GSTIN EXIST AND CANCAN
  def prepare_for_gstin(gstin, user_ip_address, current_user)
    Rails.logger.info("Preparing for GSTIN #{gstin.gstin_number} #{gstin.gsp_environment} #{gstin.endpoint_name}")

    self.environment = gstin.gsp_environment.to_sym
    self.endpoint = gstin.endpoint_name.present? ? gstin.endpoint_name.constantize : nil
    self.gstin = gstin.gstin_number
    self.gstin_model = gstin
    self.state_code = gstin.state_code
    self.username = gstin.username
    self.user_ip = user_ip_address
    self.auth_token = gstin.auth_token
    self.token_expires_at = gstin.auth_token_expires_at
    self.expires_at = gstin.auth_expires_at
    self.encrypted_sek = gstin.auth_encrypted_sek
    self.domain_name = current_user.domain.name
    self.current_user_email = current_user.email
    self.session_encryption_key = gstin.auth_decrypted_sek
    self.current_user_id = current_user.id
  end

  def url
    "/taxpayerapi/v#{environment == :production ? '1.0' : '0.2'}/authenticate".freeze
  end
  # Makes an OTP request and also updates the instance username
  def otp_request(username = 'Shalibhadra.MH.1')
    self.username = username
    gstn_request(url, 
                 {
                   app_key: @gstn_crypto.encrypted_app_key(self.app_key, is_sandbox: environment != :production),
                   username: username
                 },
                 action: 'OTPREQUEST')
  end

  def get_auth_token(gstin_record, otp)
    response = gstn_request(url,
                            {
                              app_key: @gstn_crypto.encrypted_app_key(self.app_key, is_sandbox: environment != :production),
                              otp: @gstn_crypto.encrypt_otp(otp, self.app_key),
                              username: username
                            },
                            action: 'AUTHTOKEN')
    if is_success(response)
      load_auth_response(response[:body], true, true)
    end
    response
  end

  def evc_otp(data)
    ulc = "/taxpayerapi/v1.0/authenticate?" + data
    gstn_request(ulc, {}, {action: "EVCOTP", method: "get", headers: {'auth-token' => self.auth_token, username: self.username}})
  end

  def extend_auth_token(gstin, auth_token, username)
    # TODO save new app key and rek in gstin
    self.app_key = @gstn_crypto.generate_new_app_key
    response = gstn_request(url,
                            {
                              app_key: @gstn_crypto.encrypt_data(self.app_key, Base64.strict_decode64(session_encryption_key), false),
                              username: username.downcase,
                              auth_token: auth_token
                            },
                            action: 'REFRESHTOKEN')
    if !is_success(response)
      GstnAuthenticationFailedException.new(response[:error], response)
    else
      load_auth_response(response[:body], true, false)
      response
    end
  end  

  def authenticated_gstn_request(path, body = {}, options = {}, headers_in_body = false, hmac_required = true, utf_encoding = true, include_gstin_body = true)
    Rails.logger.info "Authenticated GSTN Request"
    Rails.logger.info body

    raise ::GstnAuthenticationFailedException.new('Please authenticate with GSTIN using OTP methods') \
        if auth_token.nil? || username.nil?

    options[:headers] ||= {}
    options[:headers][:username] = username
    options[:headers]["auth-token"] = auth_token

    new_body = body.to_hash
    data = body[:data].to_hash
    data[:gstin] = gstin if include_gstin_body
    txn_id = nil

    data = data.to_json
    Rails.logger.info "DATA"
    Rails.logger.info data

    new_body[:data] = @gstn_crypto.encrypt_data(data,
                                                Base64.strict_decode64(session_encryption_key), utf_encoding: utf_encoding)
    if hmac_required                                            
      new_body[:hmac] = @gstn_crypto.hmac_256(data,
                                              Base64.strict_decode64(session_encryption_key))
    end

    response = gstn_request(path, new_body, options, headers_in_body)
    if response[:success]
      @gstn_crypto.decrypt_api_response(response[:body]['data'],
                                        session_encryption_key,
                                        response[:body]['rek'],
                                        response[:body]['hmac'])
    else
      raise ::GstnUpstreamException.new(response[:error]['message'], response)
      response
    end
  end

  def authenticated_dsc_request(path, body = {}, options = {})
    Rails.logger.info "Authenticated DSC GSTN Request"
    Rails.logger.info body

    raise GstnAuthenticationFailedException.new('Please authenticate with GSTIN using OTP methods') \
        if auth_token.nil? || username.nil?

    options[:headers] ||= {}
    options[:headers][:username] = username
    options[:headers]["auth-token"] = auth_token
    options[:dsc] = true

    new_body =  body[:data].as_json
    Rails.logger.info "DATA"
    Rails.logger.info new_body

    response = gstn_request(path, new_body, options)

    if response[:success]
      response
    else
      GstnUpstreamException.new(response[:error], response)
      response
    end
  end

  def audit_request_for_unauthorized_gstone(headers, body, action, response)
    object = audit_request(headers, body, action)
    object.username = username
    object.response_at = DateTime.now
    object.response_type = 'Invalid'
    object.invalid_reason = response.parsed_response
    object.response_headers = response.headers
    object.save
    object
  end

  protected

  def generate_new_app_key
    SecureRandom.hex(16)
  end

  def audit_request(headers, body, action)
    object = super
    object.username = username
    object.save
    object
  end

  def is_success(response)
    response[:success] && response[:body]["status_cd"] != "0"
  end

  private

  def load_auth_response(body, update_gstin = false, update_expires_at = false)
    self.auth_token = body['auth_token']
    self.expires_at = Time.now + Integer(body['expiry']).minutes if update_expires_at
    self.encrypted_sek = body['sek']
    self.session_encryption_key = @gstn_crypto.decrypt_data(body['sek'], self.app_key)
    self.token_expires_at = Time.now + 6.hours
    if update_gstin
      gstin_model.load_auth_attributes_from(self, update_expires_at)
      gstin_model.save
    end
    Rails.logger.info "Authentication Data #{auth_token} #{expires_at} #{encrypted_sek} #{session_encryption_key}"
  end
end
