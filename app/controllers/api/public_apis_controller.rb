class Api::PublicApisController < Api::SubscriptionActiveController
  include Swagger::Blocks

  skip_before_action :authenticate_user!
  skip_before_action :check_roles
  skip_before_action :check_email_verified
  skip_before_action :check_phone_verified
  skip_before_action :check_subcription_active

  def initialize
    @@public_api ||= Gsp::PublicAuthenticatedApi.new
  end

  respond_to :json

  swagger_schema :PublicApiAuthenticateModel do
    key :required, %i[token est]
    property :username do
      key :type, :string
      key :message, 'username'
    end
    property :password do
      key :type, :string
      key :message, 'password'
    end
  end

  swagger_path '/api/public_apis/common_authenticate' do
    operation :post do
      key :description, 'authenticate with common api'
      key :operationId, 'getCommonApiAuth'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'asp-id'
        key :in, :header
        key :description, 'Asp ID'
        key :required, false
        key :type, :string
      end
      response 200 do
        schema do
          key :'$ref', :PublicApiAuthenticateModel
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def common_authenticate 
    username = request.headers['username']
    password = request.headers['password']
    common_response = {}
    auth_token = ""
    if username.nil? || password.nil?
      return render json: {message: "Please provide username and password"}, status: :ok 
    end
    asp = Asp.where(username: username, 'secret_password': password).first
    if asp.present? and asp.is_active.to_sym == :yes
      @common_auth = CommonApiAuth.first
      if @common_auth.nil?
        @common_auth = CommonApiAuth.new
        @common_auth.auth_token = ""
        @common_auth.save
      end
      if @common_auth&.auth_token == "" || @common_auth&.auth_token.nil? || @common_auth&.auth_token_expires_at < Time.now
        @@public_api.asp_username = username
        @@public_api.asp_id = request.headers['asp-id']
        auth_response = @@public_api.common_authenticate
        if auth_response['status_cd'] == "1"
          @common_auth.delay(run_at: (6.hours - 15.minutes).from_now(Time.now)).refresh_auth_token(auth_response)
          auth_token = auth_response['auth_token']
        else 
          return render json: { message: auth_response }, status: :internal_server_error 
        end
      else
        auth_token = @common_auth.auth_token  
      end
      common_response = {
        auth_token: auth_token
      }
      asp.token_request_count = (asp.token_request_count.nil? ? 0 : asp.token_request_count) + 1
      asp.save
    else
      return render json: { message: "Invalid User" }, status: :ok 
    end
    return render json: common_response, status: :ok 
  end


  swagger_path '/api/public_apis/search_taxpayer' do
    operation :post do
      key :description, 'Enter Gstin '
      key :operationId, 'getCommonApiGstin'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'token'
        key :in, :header
        key :description, 'token'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'asp-id'
        key :in, :header
        key :description, 'Asp ID'
        key :required, false
        key :type, :string
      end
      parameter do
        key :name, :gstins
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseGstinModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end
  def search_taxpayer
    common_taxpayer_search('v1.0')
  end

  swagger_path '/api/public_apis/search_taxpayer_v1.2' do
    operation :post do
      key :description, 'Enter Gstin '
      key :operationId, 'getCommonApiGstin'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'token'
        key :in, :header
        key :description, 'token'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'asp-id'
        key :in, :header
        key :description, 'Asp Id'
        key :required, false
        key :type, :string
      end
      parameter do
        key :name, :gstins
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseGstinModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def search_taxpayer_new_version
    common_taxpayer_search('v1.1')
  end


  swagger_path '/api/public_apis/view_and_track_status' do
    operation :post do
      key :description, 'Enter Gstin '
      key :operationId, 'getCommonApiGstin'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'token'
        key :in, :header
        key :description, 'token'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'asp-id'
        key :in, :header
        key :description, 'Asp ID'
        key :required, false
        key :type, :string
      end
      parameter do
        key :name, :public_api
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :ViewAndTrackStatus
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def view_and_track_status
    final_response = []
    auth_token = request.headers['token']
    username = request.headers['username']
    password = request.headers['password']
    if auth_token.nil?
      return render json: {message: "Please Provide auth token"}, status: :ok 
    end
    if username.nil? || password.nil?
      return render json: {message: "Please Provide username and password"}, status: :ok 
    end
    asp = Asp.where(username: username, 'secret_password': password).first
    if asp.present? and asp.is_active.to_sym == :yes
      permit_params = params[:public_api].permit(:gstin, :fy, :type)
      permit_params = permit_params.to_hash.reject { |k,v| v.empty? }
      @@public_api.auth_token = auth_token
      @@public_api.asp_id = request.headers['asp-id']
      @@public_api.asp_username = username
      gstin = permit_params['gstin']
      @@public_api.gstin = gstin
      gst_response = @@public_api.view_track_status(permit_params.to_query)
      asp.gstin_request_count = (asp.gstin_request_count.nil? ? 0 : asp.gstin_request_count) + 1
      asp.save
      if gst_response["status_cd"] != "0"
        gst_response = JSON.parse(gst_response)
      else  
        gst_response['gstin'] = gstin
      end
      final_response.push(gst_response)
      return render json: final_response, status: :ok
    else
      return render json: { message: "Invalid User" }, status: :ok 
    end  
  end

  
  swagger_path '/api/public_apis/search_by_pan' do
    operation :post do
      key :description, 'Enter Pan '
      key :operationId, 'getCommonApiGstin'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'token'
        key :in, :header
        key :description, 'token'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'asp-id'
        key :in, :header
        key :description, 'Asp Id'
        key :required, false
        key :type, :string
      end
      parameter do
        key :name, :pan_number
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BasePanModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def search_by_pan
    username = request.headers['username']
    password = request.headers['password']
    auth_token = request.headers['token']
    common_auth = CommonApiAuth.first
    if auth_token.nil?
      render json: {message: "Please Provide auth token"}, status: :ok 
    end
    if username.nil? || password.nil?
      render json: {message: "Please Provide username and password"}, status: :ok 
    end
    asp = Asp.where(username: username, 'secret_password': password).first
    if asp.present? && asp.is_active.to_sym == :yes
      pan_number = params[:pan_number]
      @@public_api.auth_token = auth_token
      @@public_api.asp_username = username
      @@public_api.asp_id = request.headers['asp-id']
      response = @@public_api.search_by_pan(pan_number)
    else
     render json: { message: "Invalid User" }, status: :ok and return
    end
    render json: { message: response }, status: :ok
  end

  swagger_path '/api/public_apis/session_destroy' do
    operation :post do
      key :description, 'Session Logout'
      key :operationId, 'getCommonApiGstin'
      key :tags, ['commonAPI']
      parameter do
        key :name, :'token'
        key :in, :header
        key :description, 'token'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'username'
        key :in, :header
        key :description, 'username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'password'
        key :in, :header
        key :description, 'password'
        key :required, true
        key :type, :string
      end
      response 200 do
        schema do
          key :'$ref', :SessionDestroy
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def session_destroy
    username = request.headers['username']
    auth_token = request.headers['token']
    password = request.headers['password']
    common_auth = CommonApiAuth.first
    if common_auth.present? && auth_token == common_auth.auth_token
      asp = Asp.where(username: username, secret_password: password).first
      if asp.present?
        @@public_api.asp_username = username
        response = @@public_api.session_destroy
        if response['status_cd'] == 1
          return render json: {message: "Your Session is detroyed successfully"}, status: :ok
        else
          return render json: {message: response["error"]}, status: :ok
        end
      else
        return render json: {message: "Invalid User"}, status: :ok
      end
    else
      return render json: {message: "Please provide valid token or re-generate token"}, status: :ok
    end

  end

  private

    def common_taxpayer_search version
      final_response = []
      auth_token = request.headers['token']
      username = request.headers['username']
      password = request.headers['password']
      if auth_token.nil?
        return render json: {message: "Please Provide auth token"}, status: :ok 
      end
      if username.nil? || password.nil?
        return render json: {message: "Please Provide username and password"}, status: :ok 
      end
      asp = Asp.where(username: username, 'secret_password': password).first
      if asp.present? and asp.is_active.to_sym == :yes
        gstins = params[:gstins]
        gstins.each do |gstin|
          @@public_api.auth_token = auth_token
          @@public_api.asp_username = username
          @@public_api.gstin = gstin
          @@public_api.asp_id = request.headers['asp-id']
          gst_response = @@public_api.search_taxpayer(gstin, version)
          asp.gstin_request_count = (asp.gstin_request_count.nil? ? 0 : asp.gstin_request_count) + 1
          asp.save
          if gst_response["status_cd"] != "0"
            if gst_response.class == String
              gst_response = JSON.parse(gst_response)
            end
          else  
            gst_response['gstin'] = gstin
          end
          final_response.push(gst_response)
        end
        return render json: final_response, status: :ok
      else
        return render json: { message: "Invalid User" }, status: :ok 
      end
    end
end