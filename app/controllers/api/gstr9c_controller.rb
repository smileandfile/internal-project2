class Api::Gstr9cController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks

  respond_to :json

  swagger_path '/api/gstr9c/generate_certi' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to generate GSTR9C certificate data.'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :certi_request
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseCertiModal
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

  def generate_certi
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = params.permit(:gstin, :fp, :isauditor, cert_data: {})
    payload = {
      gstin: data[:gstin],
      fp: data[:fp],
      isauditor: data[:isauditor],
      cert_data: data[:cert_data]
    }
    response = gstr9c.generate_certi(payload)

    render json: response, status: :ok
  end

  swagger_path '/api/gstr9c/save_gstr9c' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to save GSTR9C data.'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :data
        key :in, :body
        key :type, :string
        schema do
          property :gstr9cdata do
            key :type, :object
          end
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

  def save_gstr9c 
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = select_hash_values(params[:gstr9c], [:gstr9cdata])
    payload = {
      gstr9cdata: data[:gstr9cdata]
    }
    response = gstr9c.save_gstr9c(payload)

    render json: response, status: :ok
  end

  swagger_path '/api/gstr9c/gstr9_records' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to get GSTR9 data for GSTR9C'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :return_period
        key :in, :query
        key :description, 'Return Period'
        key :type, :string
        key :required, true
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

  def gstr9_records
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = select_hash_values(params, [:return_period], {return_period: :ret_period})
    response = gstr9c.gstr9_records(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstr9c/file_gstr9c' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to File GSTR9c with DSC/EVC Sign.'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :data
        key :in, :body
        key :type, :string
        schema do
          property :gstr9cdata do
            key :type, :object
          end
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

  def file_gstr9c 
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = select_hash_values(params[:gstr9c], [:gstr9cdata])
    payload = {
      gstr9cdata: data[:gstr9cdata]
    }
    response = gstr9c.file_gstr9c(payload)

    render json: response, status: :ok
  end

  swagger_path '/api/gstr9c/summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to get GSTR9C Summary details'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :return_period
        key :in, :query
        key :description, 'Return Period'
        key :type, :string
        key :required, true
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

  def summary
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = select_hash_values(params, [:return_period], {return_period: :ret_period})
    response = gstr9c.summary(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstr9c/hash_generator' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to generate hash data.'
      key :operationId, 'gstr9cFile'
      key :tags, ['gstr9c']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :data
        key :in, :body
        key :type, :string
        schema do
          property :gstr9cdata do
            key :type, :object
          end
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

  def hash_generator
    gstr9c = Gsp::Gstr9c.new(@@gsp_api)
    data = select_hash_values(params[:gstr9c], [:gstr9cdata])
    payload = {
      gstr9cdata: data[:gstr9cdata]
    }
    response = gstr9c.hash_generator(payload)

    render json: response, status: :ok
  end
end