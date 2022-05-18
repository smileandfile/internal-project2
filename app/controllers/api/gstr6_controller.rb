class Api::Gstr6Controller < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period
  respond_to :json

  swagger_path '/api/gstr6/save_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is used to save entire GSTR6 invoices.'
      key :operationId, 'saveInvoices'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr6.save_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/offset_late_fee' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to Offset GSTR6 Late fee .'
      key :operationId, 'offsetLateFee'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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

  def offset_late_fee
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr6.offset_late_fee(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/b2b_invoices' do
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
      key :operationId, 'GetB2BInvoices'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :action_required, :from_time]
                                          ))
    response = gstr6.b2b_invoices(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr6/cdn_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Credit/Debit notes invoices for a return period.'
      key :operationId, 'GetcdnInvoices'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :action_required, :from_time]
                                          ))
    response = gstr6.cdn_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/isd_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all ISD invoices for a return period.'
      key :operationId, 'GetIsdDetails'
      key :tags, ['gstr6']
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

  def isd_details
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.isd_details(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting summary.'
      key :operationId, 'GetSummary'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Gstr6SummaryModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstr6SummaryModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def summary
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.summary(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/late_fee' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting late fee'
      key :operationId, 'GetLateFee'
      key :tags, ['gstr6']
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

  def late_fee
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.late_fee(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/itc_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting ITC details'
      key :operationId, 'GetItcDetails'
      key :tags, ['gstr6']
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

  def itc_details
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.itc_details(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/mismatch_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting mismatch_details details'
      key :operationId, 'GetMismatchDetails'
      key :tags, ['gstr6']
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

  def mismatch_details
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.mismatch_details(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/refund_claim' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting refund_claim details'
      key :operationId, 'GetRefundClaim'
      key :tags, ['gstr6']
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

  def refund_claim
    # # here you make instance of
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    # # then call
    response = gstr6.refund_claim(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/submit_refund_claim' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for submitting refund claim.'
      key :operationId, 'submitRefundClaimGSTR6'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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

  def submit_refund_claim
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr6.submit_refund_claim(@data)
    render json: response, status: :ok
  end




  swagger_path '/api/gstr6/submit' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for submitting gstr6.'
      key :operationId, 'submitGSTR6'
      key :tags, ['gstr6']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr6
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

  def submit
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr6.submit(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr6/file_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR6 with ESIGNing. Please perform AADHAAR OTP request before hitting this API.'
      key :operationId, 'fileGSTR4Esign'
      key :tags, ['gstr6']
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

  def file_esign
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
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
    response = gstr6.file_gstr6(payload)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr6/file_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR6 with DSC. Please perform signing of data before hitting this API.'
      key :operationId, 'fileGSTR6Dsc'
      key :tags, ['gstr6']
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

  def file_dsc
    gstr6 = Gsp::Gstr6.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr6.file_gstr6(payload)
    render json: response, status: :ok
  end

end
