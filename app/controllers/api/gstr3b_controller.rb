require "json-schema"
class Api::Gstr3bController < Api::GstnBaseController
  include Swagger::Blocks
  include SelectHashValues
  before_action :get_return_period
  respond_to :json

  swagger_schema :Gstr3bDataModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :data]
        property :data do
          key :type, :object
        end
      end
    end
  end

  swagger_schema :Gstr3bTrackStatusModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :reference_id]
        property :reference_id do
          key :type, :string
        end
      end
    end
  end

  swagger_path '/api/gstr3b/gstr3b_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET GSTR3B Details'
      key :operationId, 'GetGSTR3BDetails'
      key :tags, ['gstr3b']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3b
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

  def gstr3b_details
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    response= gstr3b.get_gstr3b_details(@data)
    render json: response, status: :ok
  end

    swagger_path '/api/gstr3b/track_status' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GSTR3B track status'
      key :operationId, 'GetGSTR3BTrackStatus'
      key :tags, ['gstr3b']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3b
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Gstr3bTrackStatusModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstr3bTrackStatusModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def track_status
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
     @data = @data.merge(select_hash_values(params,
                               [:return_period, :reference_id],
                               {return_period: :ret_period, reference_id: :ref_id}
                         ))
    response= gstr3b.track_status(@data)
    render json: response, status: :ok
  end





  swagger_path '/api/gstr3b/submit_gstr3b' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Submit GSTR3B'
      key :operationId, 'submitGSTR3B'
      key :tags, ['gstr3b']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3b
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

  def submit_gstr3b
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    response = gstr3b.submit_gstr3b(@data)
    render json: response, status: :ok
  end

    swagger_path '/api/gstr3b/save_gstr3b' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for Saving GSTR3B'
      key :operationId, 'saveGstr3b'
      key :tags, ['gstr3b']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3b
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Gstr3bDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstr3bDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def save_gstr3b
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3b.save_gstr3b(@data)
    render json: response, status: :ok
  end

    swagger_path '/api/gstr3b/offset_liability' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for offset liability of GSTR3B'
      key :operationId, 'offsetLiabilityGstr3b'
      key :tags, ['gstr3b']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3b
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Gstr3bDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstr3bDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def offset_liability
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3b.offset_liability_gstr3b(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3b/file_gstr3b_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR3B with DSC. Please perform signing of data before hitting this API.'
      key :operationId, 'postGSTR3B'
      key :tags, ['gstr3b']
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

  def file_gstr3b_dsc
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr3b.file_gstr3b(payload)
    render json: response, status: :ok
  end




end
