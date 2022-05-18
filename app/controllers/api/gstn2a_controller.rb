class Api::Gstn2aController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period
  respond_to :json

  swagger_schema :BaseCtinModel do
    key :required, [:return_period]
    property :return_period  do
      key :type, :string
      key :message, 'RETURN PERIOD Ex. 052017'
    end
    property :ctin do
      key :type, :string
    end
  end


  swagger_path '/api/gstn2a/b2b_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2B Invoices'
      key :operationId, 'GetB2BInvoices'
      key :tags, ['gstn2a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn2a
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseCtinModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseCtinModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def b2b_invoices
    # # here you make instance of
    gstr2a = Gsp::Gstr2a.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin]
                                          ))
    response= gstr2a.B2B_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn2a/cdn_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET CDN Invoices'
      key :operationId, 'GetCDNInvoices'
      key :tags, ['gstn2a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn2a
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseCtinModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseCtinModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def cdn_invoices
    # # here you make instance of
    gstr2a = Gsp::Gstr2a.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin]
                                          ))
    response= gstr2a.CDN_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn2a/isd_credit' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices in GSTR2A related to ISD credit.'
      key :operationId, 'GetISDCredit'
      key :tags, ['gstn2a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn2a
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :CtinReturnPeriodModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :CtinReturnPeriodModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def isd_credit
    # # here you make instance of
    gstr2a = Gsp::Gstr2a.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin]
                                          ))
    response = gstr2a.isd_credit(@data)
    render json: response, status: :ok
  end




  protected
  def self.gstin_id_header_required?
    true
  end
end
