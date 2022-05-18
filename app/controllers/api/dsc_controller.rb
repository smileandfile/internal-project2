require 'digest'

class Api::DscController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  respond_to :json

  swagger_schema :DscRequestModel do
    key :required, [:data, :sign]
    property :data do
      key :type, :string
      key :message, 'PAN Number of Authorized Signatory'
    end
    property :sign do
      key :type, :string
      key :message, 'Base64 encoded PKCS7 Certificate'
    end
  end

  swagger_path '/api/dsc/register' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Register DSC with GSTN'
      key :operationId, 'registerDsc'
      key :tags, ['dsc']
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
          key :'$ref', :DscRequestModel
        end
      end
      response 200 do
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def register
    dsc = Gsp::Dsc.new(@@gsp_api)
    @data = select_hash_values(params, [:data, :sign])
    response = dsc.register(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/dsc/deregister' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Register DSC with GSTN'
      key :operationId, 'registerDsc'
      key :tags, ['dsc']
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
          key :'$ref', :DscRequestModel
        end
      end
      response 200 do
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def deregister
    dsc = Gsp::Dsc.new(@@gsp_api)
    @data = select_hash_values(params, [:data, :sign])
    response = dsc.deregister(@data)
    render json: response, status: :ok
  end

  protected

  def self.gstin_id_header_required?
    true
  end
end
