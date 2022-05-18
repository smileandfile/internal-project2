class Api::Gstr9Controller < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period, only: [:file_details, :calculate_details]
  respond_to :json

  swagger_path '/api/gstr9/file_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get GSTR9 File Details'
      key :operationId, 'gstr9File'
      key :tags, ['gstr9']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr9
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseReturnPeriodModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnPeriodModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def file_details
    gstr9 = Gsp::Gstr9.new(@@gsp_api)
    response = gstr9.file_details(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr9/file_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, ''
      key :operationId, 'gstr9File'
      key :tags, ['gstr9']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr9
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :DscRequest
            end
            schema do
              key :'$ref', :GstrDataModel
            end
          end
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def file_dsc
    gstr9 = Gsp::Gstr9.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr9.file_gstr9(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr9/save_data' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, ''
      key :operationId, 'gstr9File'
      key :tags, ['gstr9']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr9
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :Gstr9DataModel
            end
          end
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstr9DataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def save_data
    gstr9 = Gsp::Gstr9.new(@@gsp_api)
    secure_params = params.permit(:fp, data: {})
    payload = {
      fp: secure_params[:fp],
      data: secure_params[:data]
    }
    respone = gstr9.save_data(payload)
    render json: respone, status: :ok
  end

  swagger_path '/api/gstr9/calculate_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get GSTR9 File Details'
      key :operationId, 'gstr9File'
      key :tags, ['gstr9']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr9
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseReturnPeriodModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnPeriodModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def calculate_details
    gstr9 = Gsp::Gstr9.new(@@gsp_api)
    response = gstr9.calculate_details(@data)
    render json: response, status: :ok
  end

end