require 'digest'

class Api::Gstn1Controller < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period
  respond_to :json

  swagger_path '/api/gstn1/save_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Save Invoices please visit BASEURL/gstn1_api'
      key :operationId, 'saveInvoices'
      key :tags, ['gstn1']
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
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr1.save_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2b_invoices' do
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
      key :tags, ['gstn1']
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
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :from_time, :action_required]
                                          ))
    response = gstr1.B2B_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/cdnr_invoices' do
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
      key :tags, ['gstn1']
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
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:from_time, :action_required]
                                          ))
    response = gstr1.CDNR_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2ba_invoices' do
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
      key :tags, ['gstn1']
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

  # version v0.3 is not available yet
  def b2ba_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params, [:action_required]))
    response = gstr1.B2BA_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/cdnra_invoices' do
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
      key :tags, ['gstn1']
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

  # version v0.3 is not available yet
  def cdnra_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params, [:action_required]))
    response = gstr1.CDNRA_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2cla_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2CLA Invoices'
      key :operationId, 'GetB2CLAInvoices'
      key :tags, ['gstn1']
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
          key :'$ref', :BaseStateCodeModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseStateCodeModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  # version v0.3 is not available yet
  def b2cla_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:state_code],
                                           {state_code: :state_cd}
                                          ))
    response = gstr1.B2CLA_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2csa_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2CSA Invoices'
      key :operationId, 'GetB2CSAInvoices'
      key :tags, ['gstn1']
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
          key :'$ref', :BaseStateCodeModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseStateCodeModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  # version v0.3 is not available yet
  def b2csa_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:state_code],
                                           {state_code: :state_cd}
                                          ))
    response = gstr1.B2CSA_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2cl_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2CL Invoices'
      key :operationId, 'GetB2CLInvoices'
      key :tags, ['gstn1']
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
          key :'$ref', :BaseStateCodeModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseStateCodeModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def b2cl_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:state_code],
                                           {state_code: :state_cd}
                                          ))
    response = gstr1.B2CL_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/b2cs_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2CS Invoices'
      key :operationId, 'GetB2CSInvoices'
      key :tags, ['gstn1']
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

  def b2cs_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.B2CS_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/cdnura_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET CDNURA Invoices'
      key :operationId, 'GetCDNURAInvoices'
      key :tags, ['gstn1']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'reubturn_period'
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

  # version v0.3 is not available yet
  def cdnura_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response= gstr1.CDNURA_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/exp' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices related to supplies exported for a return period.'
      key :operationId, 'GetSuppliesExportedInvoices'
      key :tags, ['gstn1']
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

  def exp
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.exp(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/expa' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting amended invoices related to supplies exported
                         for a return period.'
      key :operationId, 'GetSuppliesExportedAmendedInvoices'
      key :tags, ['gstn1']
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

  # version v0.3 is not available yet
  def expa
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response= gstr1.expa(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/nil_rated' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call NIL for getting liabilities'
      key :operationId, 'GetLiabilities'
      key :tags, ['gstn1']
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

  def nil_rated
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.nil_rated(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstn1/file_gstr1_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR1 with ESIGNing. Please perform AADHAAR OTP request before hitting this API.'
      key :operationId, 'postGSTR1'
      key :tags, ['gstn1']
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
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
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
    response = gstr1.file_gstr1(payload)
    render json: response, status: :ok
  end
  swagger_path '/api/gstn1/file_gstr1_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR1 with DSC. Please perform signing of data before hitting this API.'
      key :operationId, 'postGSTR1'
      key :tags, ['gstn1']
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

  def file_gstr1_dsc
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr1.file_gstr1(payload)
    render json: response, status: :ok
  end




  swagger_path '/api/gstn1/return_status' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET return status'
      key :operationId, 'GetReturnStatus'
      key :tags, ['commonGSTAPI']
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
          key :'$ref', :ReturnStatusModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :ReturnStatusModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def return_status
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:reference_id],
                                           {reference_id: :ref_id}
                                          ))
    response = gstr1.return_status(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/gstr1_summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET GSTR1 summary'
      key :operationId, 'Getgstr1Summary'
      key :tags, ['gstn1']
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

  def gstr1_summary
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    response = gstr1.gstr1_summary(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/submit_gstr1' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Submit GSTR1 please visit BASEURL/gstn1_api'
      key :operationId, 'submitGSTR1'
      key :tags, ['gstn1']
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

  def submit_gstr1
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr1.submit_gstr1(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/at' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting advance tax details for a return period.'
      key :operationId, 'GetAdvanceTaxDetails'
      key :tags, ['gstn1']
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

  def at
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.at(@data)
    render json: response, status: :ok

  end

  swagger_path '/api/gstn1/ata' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting amended advance tax details for a return period.'
      key :operationId, 'GetAmendedAdvanceTaxDetails'
      key :tags, ['gstn1']
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

  # version v0.3 is not available yet
  def ata
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response= gstr1.ata(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/txpa' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API calls to get TXPA invoices for the tax period.'
      key :operationId, 'GetTaxPaidInvoices'
      key :tags, ['gstn1']
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

  def txpa
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    response = gstr1.txpa(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/cdnur_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API will call CDNUR for getting all Credit/Debit notes for Unregistered Users'
      key :operationId, 'GetCredit/DebitNotes'
      key :tags, ['gstn1']
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

  def cdnur_invoices
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.cdnur(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/doc_issued' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API calls to get Documents issued during the tax period'
      key :operationId, 'GetDocuments'
      key :tags, ['gstn1']
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

  def doc_issued
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    response = gstr1.doc_issued(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/txp' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting tax paid details for a return period.'
      key :operationId, 'getTaxPaidDetails'
      key :tags, ['gstn1']
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

  def txp
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    response = gstr1.txp(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/hsn_summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting HSN Summary details.'
      key :operationId, 'GetHsnSummaryDetails'
      key :tags, ['gstn1']
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

  def hsn_summary
    # # here you make instance of
    gstr1 = Gsp::Gstr1.new(@@gsp_api)
    # # then call
    response = gstr1.hsn_summary(@data)
    render json: response, status: :ok
  end


  protected
  def self.gstin_id_header_required?
    true
  end

end
