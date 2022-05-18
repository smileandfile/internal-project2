require 'exceptions'

ENV['PUBLIC_API_PASSWORD'] = ENV['PUBLIC_API_PASSWORD'] || "Rstar!007" 
class Gsp::PublicAuthenticatedApi < Gsp::BaseApi
  include HTTParty
  debug_output $stdout

  attr_accessor :app_key, :jwt_token, :environment, :endpoint, :auth_token, :sek, :asp_username, :gstin, :asp_id


  def initialize
    @gstn_crypto = GstnCrypto.new
    self.endpoint = 'Gsp::Endpoints::GspOneEndpoint'.constantize
    self.environment = 'production'
  end

  # response =  {"status_cd":"1","auth_token":"d146903a51a6402d83d533ec09b5b77e","sek":"ni8zO8xj8wH0ZRL9QO7FQX9Xzlx5v0IfXFddI5AeSA486rlgAo7jWdA2OhpohwGd"}                              
  def common_authenticate
    encrypted_app_key =  @gstn_crypto.encrypted_app_key(@gstn_crypto.generate_new_app_key, is_sandbox: false)
    auth_response = gstn_request("/commonapi/v1.0/authenticate", 
                 {
                   app_key: encrypted_app_key,
                   username: 'GSPShalib',
                   password: @gstn_crypto.encrypted_app_key(ENV['PUBLIC_API_PASSWORD'], is_sandbox: false)
                 },
                 action: 'ACCESSTOKEN')
    auth_response = auth_response.parsed_response   
    update_auth_token(auth_response, encrypted_app_key) if auth_response['status_cd'] == '1'
    auth_response
  end

  def search_taxpayer(data, version)
    url = "/commonapi/#{version}/search?gstin=" + data
    response = gstn_request(url, 
                            {},
                            {action: 'TP', method: 'get'})
    case response.code
      when 200
        response = response.parsed_response   

        if response['status_cd'] == '1'
          Base64.strict_decode64(response['data'])
        else
          response 
        end  
      when 400...600
        raise ::GstnUpstreamConnectionError.new("502 Bad Gateway", {response_cd: "#{response.code}"})
    end
  end

  def view_track_status(data)
    url = "/commonapi/v1.0/returns?" + data
    response = gstn_request(url, 
                            {},
                            {action: 'RETTRACK', method: 'get'})
    response = response.parsed_response   
    if response['status_cd'] == '1'
      Base64.strict_decode64(response['data'])
    else
      response 
    end  
  end

  def search_by_pan pan_number
    url = "/commonapi/v1.0/search?pan=" + pan_number
    response = gstn_request(url,
                            {},
                            {action: 'TPPAN', method: 'get'}
                           )
    response = response.parsed_response
  end

  def session_destroy
    common_auth = CommonApiAuth.first
    response = gstn_request("/commonapi/v0.2/authenticate", 
                            {
                              username: 'GSPShalib',
                              app_key: common_auth.encrypted_app_key,
                              auth_token: common_auth.auth_token
                            },
                            {action: 'LOGOUT', method: 'post'})
    response = response.parsed_response
    response
  end

  def is_success(response)
    response[:success] && response[:body]["status_cd"] != "0"
  end

  def _gstn_request(path, body, options, endpoint, headers_in_body)
    method = options[:method] || 'post'
    body = body.to_hash
    action = options[:action]
    headers = options[:headers] || {}
    headers = headers.merge!('Content-Type' => 'application/json') \
                     .merge!(base_headers)
    actual_body = action.nil? ? body : body.merge!(action: action).to_json
    if method == 'get'
      headers.merge!('auth-token': self.auth_token) unless self.auth_token.nil?
      actual_body = nil
      path = path + (path.include?('?') ? '&' : '?') + 'action=' + action
    end
    audit_object = audit_request(action)
    response = making_request_and_handle_exception do 
                self.class.send(method,
                                path,
                                headers: headers,
                                body: actual_body)
               end
    audit_resposne(response.parsed_response, audit_object)
    response
  end

  def audit_request(action)
    audit_request = CommonApiLog.create(
      requested_at: DateTime.now,
      gstin: self.gstin,
      request_headers: {asp_username: self.asp_username, asp_id: self.asp_id},
      api_name: action,
      username: asp_username,
      base_url: @base_url,
    )
    audit_request
  end

  def audit_resposne(response, audit_object)
    audit_object.response_at = DateTime.now
    audit_object.response_type = response['status_cd'] == '1' ? 'Valid' : 'Invalid'
    audit_object.invalid_reason = response["error"]
    audit_object.save
  end

  def base_headers
    {
      'username': 'GSPShalib',
      clientid: 'l7xx0db84796716049edb7af8a3bf4eed6eb',
      'client-secret' => '48ddaf4d65214b64a83ccc245380873a',
      txn: transaction_id,
      'ip-usr' => '115.248.189.69' || '196.207.85.234'
    }
  end

  def base_url=(url)
    @base_url = url
    self.class.base_uri(url)
  end

  private

  def update_auth_token(auth_response, encrypted_app_key)
    self.auth_token = auth_response['auth_token']
    self.sek = auth_response['sek']
    common_api = CommonApiAuth.first
    common_api.update_auth_token(auth_response, encrypted_app_key)
    common_api.save!
    return auth_response
  end

end