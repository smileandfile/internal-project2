class Api::Gstr2Controller < Api::GstnBaseController
  include Swagger::Blocks
  include SelectHashValues
  before_action :get_return_period
  respond_to :json

  swagger_path '/api/gstr2/b2b_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all B2B invoices for a return period.'
      key :operationId, 'Gstr2B2BInvoices'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :from_time, :action_required]
                                          ))
    response = gstr2.B2B_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/import_goods_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices related to Import of Goods/Capital for a return period.'
      key :operationId, 'Gstr2GoodsInvoices'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def import_goods_invoices
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.get_import_goods_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/import_service_bills' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices related to Import of Services for a return period.'
      key :operationId, 'Gstr2ImportServiceBills'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def import_service_bills
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.get_import_service_bills(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/cdn_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all cdn invoices for a return period.'
      key :operationId, 'Gstr2CDNInvoices'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def cdn_invoices
    # # here you make instance of
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :from_time, :action_required]
                                          ))
    response = gstr2.cdn_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/nil_rated' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices related to Nil related for a return period.'
      key :operationId, 'Gstr2NilRated'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def nil_rated
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.nil_rated(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/tax_liability_reverse_charge_summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting Item details related to Tax liability under reverse charge.'
      key :operationId, 'Gstr2TaxLiabilityReverseChargeSummary'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def tax_liability_reverse_charge_summary
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.tax_liability_reverse_charge_summary(@data)
    render json: response, status: :ok
  end
  
  swagger_path '/api/gstr2/tax_paid_reverse_charge' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoice details related to Tax paid under reverse charge.'
      key :operationId, 'Gstr2PaidReverseCharge'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def tax_paid_reverse_charge
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.tax_paid_reverse_charge(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/gstr2_summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET GSTR2 summary'
      key :operationId, 'Getgstr2Summary'
      key :tags, ['gstr2']
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

  def gstr2_summary
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.gstr2_summary(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/save_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is used to save entire GSTR2 invoices.'
      key :operationId, 'saveInvoices'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn2
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
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr2.save_invoices(@data)
    render json: response, status: :ok
  end
  
  swagger_path '/api/gstr2/b2bur' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting B2B Unregistered invoices for a return period.'
      key :operationId, 'GstrB2bur'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def b2bur
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.b2bur(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/cdnur' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting CDN Unregistered invoices for a return period.'
      key :operationId, 'GetCDNUR'
      key :tags, ['gstr2']
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

  def cdnur
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :from_time, :action_required]
                                          ))
    response = gstr2.cdnur(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/file_gstr2_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR2 with ESIGNing. Please perform OTP request before hitting this API.'
      key :operationId, 'postGSTR1'
      key :tags, ['gstr2']
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

  def file_gstr2_esign
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
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
    response = gstr2.file_gstr2(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/file_gstr2_dsc' do
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
      key :operationId, 'postGSTR1'
      key :tags, ['gstr2']
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

  def file_gstr2_dsc
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr2.file_gstr2(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/submit_gstr2' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Submit GSTR2'
      key :operationId, 'submitGSTR2'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def submit_gstr2
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr2.submit_gstr2(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/hsn' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get HSN summary of Inward supplies'
      key :operationId, 'GetHSNSummary'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def hsn
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.hsn(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr2/itc_rvsl' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get ITC Reversal Details'
      key :operationId, 'GetITCReversalDetails'
      key :tags, ['gstr2']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr2
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

  def itc_rvsl
    gstr2 = Gsp::Gstr2.new(@@gsp_api)
    response = gstr2.itc_rvsl(@data)
    render json: response, status: :ok
  end
end
