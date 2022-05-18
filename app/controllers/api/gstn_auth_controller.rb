class Api::GstnAuthController < Api::GstnBaseController
  include Swagger::Blocks
  before_action :set_gstin, only: [:gsp_api, :confirm_otp, :request_otp, :refresh_auth_token, :evc_otp]
  before_action :gsp_api
  respond_to :json

  swagger_schema :ConfirmOtp do
    property :gstn do
      key :type, :object
      property :otp do
        key :type, :string
      end
    end
  end

  swagger_path '/api/gstn_auth/request_otp' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Request Otp for authentication'
      key :operationId, 'requestOtp'
      key :tags, ['gstn_auth']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  swagger_path '/api/gstn_auth/confirm_otp' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Confirm Otp'
      key :operationId, 'confirmOtp'
      key :tags, ['gstn_auth']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :'gstn[otp]'
        key :in, :body
        key :description, 'OTP'
        key :required, true
        key :type, :string
        schema do
          key :'$ref', :ConfirmOtp
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def confirm_otp
    set_gstin
    @@gsp_api.app_key = Base64.strict_decode64(@gstin.app_key)
    gst_response = @@gsp_api.get_auth_token(@gstin, params[:gstn][:otp])
    begin
      if gst_response[:body]['status_cd'] == "1"
        user_ip = request.remote_ip
        @gstin.delay(run_at: (6.hours - 20.minutes).from_now(Time.now)).refresh_auth_token(user_ip, current_user)
        # @gstin.delay(run_at: 1.hours.from_now(Time.now)).refresh_auth_token(user_ip, current_user)
      end
      render json: gst_response, status: :ok
    rescue Exception => e
      render json: { msg: e.message}, status: :ok
    end  
  end


  def request_otp
    set_gstin
    app_key = GstnCrypto.new.generate_new_app_key
    @gstin.app_key = Base64.strict_encode64(app_key)
    @gstin.save
    @@gsp_api.app_key = app_key
    gst_response = @@gsp_api.otp_request(@gstin.username)
    render json: gst_response, status: :ok
  end

  swagger_path '/api/gstn_auth/refresh_auth_token' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Refresh token api'
      key :operationId, 'refreshToken'
      key :tags, ['gstn_auth']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response :unauthorized
      response :not_acceptable
    end
  end


  def refresh_auth_token
    set_gstin
    gst_response = @@gsp_api.extend_auth_token(@gstin, @gstin.auth_token, @gstin.username)
    begin
      if gst_response[:body]['status_cd'] == "1"
        user_ip = request.remote_ip
        @gstin.delay(run_at: (6.hours - 20.minutes).from_now(Time.now)).refresh_auth_token(user_ip, current_user)
      end
      render json: gst_response, status: :ok
    rescue Exception => e
      render json: { msg: e.message}, status: :ok
    end  
  end

  swagger_path '/api/gstn_auth/evc_otp' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Initiate OTP for evp'
      key :operationId, 'evpOtp'
      key :tags, ['gstn_auth']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :gstn_auth
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :OtpForEVC
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def evc_otp
    set_gstin
    permit_params = params[:gstn_auth].permit(:gstin, :pan, :form_type)
    if permit_params[:gstin].nil? || permit_params[:pan].nil? || permit_params[:form_type].nil?
     return render json: {msg: "Gstin, pand number or filing type is missing"}, status: :ok  
    end
    data = permit_params.to_query
    gst_response = @@gsp_api.evc_otp(data)
    render json: gst_response, status: :ok
  end
  

  protected
  def self.gstin_id_header_required?
    true
  end

  def set_gstin
    gstin_id = request.headers['gstin-id']
    raise GstnAuthenticationFailedException.new('GSTIN is not set') if gstin_id.nil?
    @gstin = Gstin.find(gstin_id)
  end



end