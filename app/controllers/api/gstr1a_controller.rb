require 'digest'

class Api::Gstr1aController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period
  respond_to :json



  swagger_path '/api/gstr1a/save_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Save Invoices'
      key :operationId, 'saveInvoices'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn1
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
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

  def save_invoices
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr1a.save_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/b2b_invoices' do
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
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn1
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstB2BInvoicesModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstB2BInvoicesModel
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
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :from_time, :action_required]
                                          ))
    response = gstr1a.b2b_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/cdnr_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET CDNR Invoices'
      key :operationId, 'GetCDNRInvoices'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn1
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :CDNRInvoiceModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :CDNRInvoiceModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def cdnr_invoices
    # # here you make instance of
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:from_time, :action_required]
                                          ))
    response = gstr1a.cdnr_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/b2ba_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2BA Invoices'
      key :operationId, 'GetB2BAInvoices'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn1
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseActionRequiredModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseActionRequiredModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def b2ba_invoices
    # # here you make instance of
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:action_required]))
    response = gstr1a.b2ba_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/cdnra_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET CDNRA Invoices'
      key :operationId, 'GetCDNRAInvoices'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn1
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseActionRequiredModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseActionRequiredModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def cdnra_invoices
    # # here you make instance of
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params, [:action_required]))
    response = gstr1a.cdnra_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/file_gstr1a_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR1a with ESIGNing. Please perform AADHAAR OTP request before hitting this API.'
      key :operationId, 'postGSTR1a'
      key :tags, ['gstr1a']
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
              key :'$ref', :AadhaarEsignRequest
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

  def file_gstr1_esign
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    payload = {
      "aadhaar_number": params[:aadhaar_number],
      "aadhaar_otp": params[:aadhaar_otp],
      "patron_id": params[:patron_id],
      "return_period": params[:return_period],
      "data": params[:data]
    };
    signzy_response = signzy_esign_data(payload)
    payload[:pkcs7_data] = signzy_response['result']['Pkcs7Response']
    payload[:sid] = params[:aadhaar_number]
    payload[:st] = 'ESIGN'
    response = gstr1a.file_gstr1a(payload)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr1a/file_gstr1a_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR1a with DSC. Please perform signing of data before hitting this API.'
      key :operationId, 'postGSTR1a'
      key :tags, ['gstr1a']
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

  def file_gstr1a_dsc
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    payload = {
      "sid": params[:pan_number],
      "return_period": params[:return_period],
      "data": params[:data],
      "pkcs7_data": params[:signed_data],
      "st": "DSC"
    }
    response = gstr1a.file_gstr1(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr1a/gstr1a_summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET GSTR1a summary'
      key :operationId, 'Getgstr1aSummary'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'return_period'
        key :in, :body
        key :description, 'RETURN PERIOD Ex. 052017'
        key :required, true
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

  def gstr1a_summary
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    response = gstr1a.gstr1a_summary(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr1a/submit_gstr1a' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Submit GSTR1a please visit BASEURL/gstn1a_api'
      key :operationId, 'submitGSTR1a'
      key :tags, ['gstr1a']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr1a
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
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

  def submit_gstr1a
    gstr1a = Gsp::Gstr1a.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr1a.submit_gstr1a(@data)
    render json: response, status: :ok
  end


  protected
  def self.gstin_id_header_required?
    true
  end

end
