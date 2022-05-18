require 'exceptions'

class Api::GstnBaseController < Api::SubscriptionActiveController
  include Swagger::Blocks
  respond_to :json

  before_action :set_gstin
  before_action :gsp_api

  def gsp_api
    @@gsp_api = Gsp::AuthenticatedApi.new()
    user_ip = request.remote_ip
    @@gsp_api.prepare_for_gstin(@gstin, user_ip, current_user)
  end

  swagger_schema :AadhaarOtpRequest do
    key :required, [:aadhaar_number]
    property :aadhaar_number do
      key :type, :string
      key :message, 'Aadhaar number of ESigner'
    end
  end


  swagger_path '/api/aadhaar_esign_otp_request' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Request OTP from Aadhaar to esign GSTR1 body'
      key :operationId, 'aadhaarOtpFileGstr1'
      key :tags, ['commonGSTAPI']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :body
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :AadhaarOtpRequest
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :AadhaarOtpRequest
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end
  def aadhaar_esign_otp_request
    raise ActionController::ParameterMissing, 'aadhaar_number is required' \
        unless params['aadhaar_number'].present?
    signzy_response = @signzy_esigner.otp_request(aadhaar_number: params['aadhaar_number'])
    render json: { success: true, patron_id: signzy_response['patronId'] }
  end

  # private

  def set_gstin
    gstin_id = request.headers['gstin-id']
    raise GstnAuthenticationFailedException.new('GSTIN is not set') if gstin_id.nil?
    @gstin = Gstin.find(gstin_id)
  end
end