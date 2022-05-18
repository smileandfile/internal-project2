class Api::Gstr4Controller < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period
  respond_to :json

  swagger_path '/api/gstr4/save_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is used to save entire GSTR4 invoices.'
      key :operationId, 'saveInvoices'
      key :tags, ['gstr4']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr4
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
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr4.save_invoices(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/b2b_invoices' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all B2B invoices of Registered taxpayer for a return period.'
      key :operationId, 'GetB2BInvoices'
      key :tags, ['gstr4']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr4
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstB2BInvoicesModelWithoutFromTime
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstB2BInvoicesModelWithoutFromTime
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
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :action_required]
                                          ))
    response = gstr4.B2B_invoices(@data)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr4/b2b_invoices_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all B2B invoices of Registered amendment  taxpayer for a return period.'
      key :operationId, 'GetB2BInvoices'
      key :tags, ['gstr4']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr4
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstB2BInvoicesModelWithoutFromTime
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstB2BInvoicesModelWithoutFromTime
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def b2b_invoices_amendment
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :action_required]
                                          ))
    response = gstr4.b2ba(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/b2b_unregistered_invoice_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all B2B invoices of unregistered amendment taxpayer for a return period.'
      key :operationId, 'GetB2BInvoices'
      key :tags, ['gstr4']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr4
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstB2BInvoicesModelWithoutFromTime
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstB2BInvoicesModelWithoutFromTime
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def b2b_unregistered_invoice_amendment
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    @data = @data.merge(select_hash_values(params,
                                           [:ctin, :action_required]
                                          ))
    response = gstr4.b2ba(@data)
    render json: response, status: :ok
  end



  swagger_path '/api/gstr4/b2b_unregistered_invoice' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET B2B Unregistered Invoices'
      key :operationId, 'GetB2BUnregisteredInvoice'
      key :tags, ['gstr4']
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

  def b2b_unregistered_invoice
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.b2b_unregistered_invoice(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr4/import_of_services' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Imports of services invoices for a return period.'
      key :operationId, 'GetImportOfServices'
      key :tags, ['gstr4']
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

  def import_of_services
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.import_of_services(@data)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr4/import_of_services_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Imports of services amendment invoices for a return period.'
      key :operationId, 'GetImportOfServices'
      key :tags, ['gstr4']
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

  def import_of_services_amendment
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.imps_amendment(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/cdnr_invoices' do
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
      key :tags, ['gstr4']
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
          key :'$ref', :CDNRInvoiceModelWithActionRequired
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :CDNRInvoiceModelWithActionRequired
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
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:action_required]
                                          ))
    response = gstr4.cdnr_invoices(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr4/cdnur' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Credit/ Debit notes issued to a Unregisterd taxpayer for a return period.'
      key :operationId, 'GetCdnur'
      key :tags, ['gstr4']
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

  def cdnur
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.cdnur(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/credit_note_invoice_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Credit/ Debit notes issued to a Unregisterd taxpayer for a return period.'
      key :operationId, 'GetCdnur'
      key :tags, ['gstr4']
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

  def credit_note_invoice_amendment
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.cdnr_amendment(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/credit_note_unregistered_invoice_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Credit/ Debit notes issued to a Unregisterd taxpayer amendment for a return period.'
      key :operationId, 'GetCdnur'
      key :tags, ['gstr4']
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

  def credit_note_unregistered_invoice_amendment
    # # here you make instance of
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    # # then call
    response = gstr4.cdnur_amendment(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr4/tax_on_outward_supplies' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting invoices for Tax on Outward Supplies for a return period.'
      key :operationId, 'GetTaxOnOutwardSupplies'
      key :tags, ['gstr4']
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

  def tax_on_outward_supplies
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.tax_on_outward_supplies(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/advances_paid' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Advances Paid invoices for a return period.'
      key :operationId, 'GetTaxOnOutwardSupplies'
      key :tags, ['gstr4']
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

  def advances_paid
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.advances_paid(@data)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr4/advances_paid_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Advances Paid amendment invoices for a return period.'
      key :operationId, 'GetTaxOnOutwardSupplies'
      key :tags, ['gstr4']
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

  def advances_paid_amendment
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.advances_paid_amendment(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/advances_adjusted_amendment' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Advances Adjusted amendment invoices for a return period.'
      key :operationId, 'GetAdvancesAdjusted'
      key :tags, ['gstr4']
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

  def advances_adjusted_amendment
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.advances_adjusted_amendment(@data)
    render json: response, status: :ok
  end
  

  swagger_path '/api/gstr4/advances_adjusted' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all Advances Adjusted invoices for a return period.'
      key :operationId, 'GetAdvancesAdjusted'
      key :tags, ['gstr4']
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

  def advances_adjusted
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.advances_adjusted(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/summary' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to get the table wise summary of GSTR4 data.'
      key :operationId, 'GetSummary'
      key :tags, ['gstr4']
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

  def summary
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.summary(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/tds' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for getting all TDS invoices for a return period.'
      key :operationId, 'GetTds'
      key :tags, ['gstr4']
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

  def tds
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    response = gstr4.tds(@data)
    render json: response, status: :ok
  end



  swagger_path '/api/gstr4/submit' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to submit the GSTR4 return.'
      key :operationId, 'submitGSTR4'
      key :tags, ['gstr4']
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

  def submit
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr4.submit(@data)
    render json: response, status: :ok
  end


  swagger_path '/api/gstr4/set_off_liability' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for setting of any pending liability for a return period.'
      key :operationId, 'setOffLiability'
      key :tags, ['gstr4']
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

  def set_off_liability
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr4.set_off_liability(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr4/file_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR4 with ESIGNing. Please perform AADHAAR OTP request before hitting this API.'
      key :operationId, 'fileGSTR4Esign'
      key :tags, ['gstr4']
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
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
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
    response = gstr1.file_gstr4(payload)
    render json: response, status: :ok
  end
  swagger_path '/api/gstr4/file_dsc' do
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
      key :operationId, 'fileGSTR4Dsc'
      key :tags, ['gstr4']
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
    gstr4 = Gsp::Gstr4.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr4.file_gstr4(payload)
    render json: response, status: :ok
  end
end
