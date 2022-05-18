# frozen_string_literal: true
require 'logging'

CLIENT_ID = 'l7xxbd1169e4eaed40c99317351fc9de09d0'
CLIENT_SECRET = '13d2d87f265c46569cf11e84bdd53748'
STATE_CD = '33'
USERNAME = 'CoderBhai.TN.1'
APPKEY = 'b3ecb60efb7145bfb87e077c27e7c207'
GSTIN = '33GSPTN2931G1ZB'
USER_IP = '115.248.189.69' || '196.207.85.234'
USE_GSTONE = ENV['USE_GSTONE'] == 'false'

# all loggers inherit the log level of the "root" logger
# but specific loggers can be given their own level
Logging.logger.root.level = :info

# similarly, the root appender will be used by all loggers
Logging.logger.root.appenders = Logging.appenders.stdout

CONNECTIONEXCEPTION = [Errno::ECONNRESET, Errno::ECONNREFUSED, SocketError]

class Gsp::BaseApi
  include HTTParty
  debug_output $stdout

  attr_accessor :gstin, :user_ip, :auth_token, :jwt_token, :debug_mode, :state_code

  attr_accessor :audit_resource_class
  attr_accessor :domain_name
  attr_accessor :current_user_email
  attr_accessor :endpoint
  attr_accessor :current_user_id

  def initialize
    @gstn_crypto = GstnCrypto.new
    @logger = Logging.logger[self]

    self.debug_mode = !ENV['HTTPARTY_DEBUG'].nil?

    self.audit_resource_class = GstAccessItem
  end

  def gstn_request(path, body = {}, options = {}, headers_in_body=false)
    endpoint_manager = Gsp::Endpoints::EndpointManager.new(environment)
    base_url_setter = proc { |url| self.base_url = url }
    request_maker = proc { |headers, endpoint|
      existing_headers = options[:headers] || {}
      new_options = options.dup
      new_options[:headers] = existing_headers.merge headers
      _gstn_request(path, body, new_options, endpoint, headers_in_body)
    }
    Rails.logger.info "Making request using endpoint #{endpoint}"
    if endpoint.present?
      endpoint_manager.make_request_with_endpoint(endpoint, self, base_url_setter, request_maker)
    else
      endpoint_manager.make_request(self, base_url_setter, request_maker)
    end
  end

  def _gstn_request(path, body, options, endpoint, headers_in_body=false)
    ensure_required_params_are_set!

    method = options[:method] || 'post'
    body = body.to_hash
    action = options[:action]
    headers = options[:headers] || {}
    # query_params = options[:query_params] || {}
    # base_headers['state-cd'] = state_code
    headers = base_headers.merge!('Content-Type' => 'application/json') \
                          .merge!(headers)
    headers['state-cd'] = state_code.to_s
    if headers_in_body
      body.merge!(hdr: headers.except('client-secret', :Authorization, 'Content-Type'))
    end
    actual_body = action.nil? ? body : body.merge!(action: action).to_json
    if options[:dsc]
      actual_body = actual_body.to_json
    end
    if method == 'get'
      actual_body = nil
      path = path + (path.include?('?') ? '&' : '?') + 'action=' + action
    end
    @logger.info "GSTN request to #{path}:#{action} Body:\n#{body}"

    Rails.logger.info "Headers"
    Rails.logger.info headers

    audit_object = audit_request(headers, actual_body, action)

    response = nil
    Prome.get(:aspone_gstn_requests_total).increment(metric_labels(options, endpoint))

    
    Prome.get(:aspone_gstn_request_duration_seconds)\
         .observe(metric_labels(options, endpoint), Benchmark.realtime {
          response = making_request_and_handle_exception do
             self.class.send(method,
                              path,
                              headers: headers,
                              body: actual_body)
           end
         })
    
    transformed_response = log_and_transform_response(response, path, action, endpoint)

    audit_response(audit_object, transformed_response, response)
    
    transformed_response
    
  end

  def making_request_and_handle_exception
    begin
      response = yield
    rescue *CONNECTIONEXCEPTION
      raise ::GstnUpstreamConnectionError.new("503 Service Unavailable", {response_cd: 503})

    rescue Net::OpenTimeout
      raise ::GstnUpstreamConnectionError.new("504 Gateway Timeout", {response_cd: 504})
    rescue OpenSSL::Cipher::CipherError
      raise ::SslDecryptionError.new("400 Bad Request Decryption Failed", {response_cd: 400})
    end
    response
  end

  def environment=(environment)
    @environment = environment.to_sym
  end

  def environment
    @environment
  end

  protected

  def metric_labels(options, endpoint)
    {
      endpoint: endpoint.to_s,
      action: options[:action],
      method: options[:method]
    }
  end

  def ensure_required_params_are_set!
    raise(ArgumentError, 'GSTIN and User IP are required') if gstin.nil? || user_ip.nil?
  end

  def transaction_id
    'ASP' + SecureRandom.hex(13)
  end

  def base_headers
    {
      clientid: CLIENT_ID,
      'client-secret' => CLIENT_SECRET,
      gstin: gstin,
      'ip-usr' => user_ip,
      'state-cd' => STATE_CD,
      txn: transaction_id
    }
  end

  def base_url=(url)
    @base_url = url
    self.class.base_uri(url)
    if environment == :staging || environment == :preprod
      self.class.ssl_ca_file "#{File.expand_path('.')}/lib/-gstgovin.crt"
    end
  end

  def audit_request(headers, body, action)
    headers = headers.with_indifferent_access
    object = audit_resource_class.create(
      requested_at: DateTime.now,
      gstin: gstin,
      return_period: headers[:ret_period],
      request_headers: headers,
      api_name: action,
      request_payload_size: body.to_s.length,
      transaction_id: headers[:txn],
      ip_address: user_ip,
      domain: domain_name,
      user_email: current_user_email,
      base_url: @base_url,
      user_id: current_user_id
    )
    object
  end

  def audit_response(audit_object, transformed_response, actual_response)
    audit_object.response_at = DateTime.now
    audit_object.response_type = transformed_response[:success] ? 'Valid' : 'Invalid'
    audit_object.invalid_reason = transformed_response[:error]
    audit_object.response_headers = actual_response.headers
    audit_object.response_payload_size = actual_response['data'].size unless actual_response['data'].nil?

    ## reference_id ???
    audit_object.save
  end

  private

  def log_and_transform_response(response, path, action, endpoint)
    base_metric_labels = {
      success: false,
      http_code: response.code,
      action: action,
      endpoint: endpoint.to_s
    }
    unless response.parsed_response.present?
      @logger.warn "GSTN request HTTP FAILED #{path}:#{action} Response:\n#{response.code}"
      Prome.get(:aspone_gstn_response_codes).increment(base_metric_labels)
      return {
        success: false,
        error: Rack::Utils::HTTP_STATUS_CODES[response.code],
        body: response.body
      }
    end

    parsed_response = response.parsed_response

    if parsed_response.is_a? String
      parsed_json = JSON.parse(parsed_response) rescue nil
      parsed_response = parsed_json if parsed_json.present?
    end

    if parsed_response['status_cd'] == '0'
      begin
        @logger.warn "GSTN request UPSTREAM FAILED #{path}:#{action} Response:\n#{parsed_response}"
        
        Prome.get(:aspone_gstn_error_response_codes).increment(
          base_metric_labels.merge(gstn_code: parsed_response['error']['error_cd'])
        )
        return {
          success: false,
          error: parsed_response['error'],
          body: parsed_response
        }
      rescue Prometheus::Client::LabelSetValidator::InvalidLabelSetError => e
        return response
      end  
    end

    Prome.get(:aspone_gstn_response_codes).increment(
      base_metric_labels.merge({success: true})
    )
    @logger.info "GSTN request SUCCESS #{path}:#{action} Response:\n#{parsed_response}"
    {
      success: true,
      error: nil,
      body: parsed_response
    }
  end

end