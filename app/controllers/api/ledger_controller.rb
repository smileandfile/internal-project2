class Api::LedgerController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period, only: [:cash_itc_balance, 
                                           :liability_ledger_return_liability,
                                           :retliab_balance]
  respond_to :json

  swagger_schema :DateLedgerModel do
    key :required, [:from_date, :to_date]
    property :from_date  do
      key :type, :string
      key :message, "Ex. 30-05-2017"
    end
    property :to_date  do
      key :type, :string
      key :message, "Ex. 30-05-2017"
    end
  end

  swagger_schema :RetliabBalanceModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :action do
          key :type, :string
        end
        property :ret_type  do
          key :type, :string
          key :message, 'String (Max Length : 3)'
        end
      end
    end
  end

  swagger_path '/api/ledger/cash_ledger' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET Cash Ledger Invoices'
      key :operationId, 'GetCashLedger'
      key :tags, ['ledger']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ledger
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :DateLedgerModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :DateLedgerModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def cash_ledger
    ledger = Gsp::Ledger.new(@@gsp_api)
    @data = select_hash_date_ledger_values(params)
    response = ledger.cash_ledger(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/ledger/itc_ledger' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET Itc Ledger Invoices'
      key :operationId, 'GetItcLedger'
      key :tags, ['ledger']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ledger
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :DateLedgerModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :DateLedgerModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def itc_ledger
    ledger = Gsp::Ledger.new(@@gsp_api)
    @data = select_hash_date_ledger_values(params)
    response = ledger.itc_ledger(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/ledger/cash_itc_balance' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get Cash ITC Balance'
      key :operationId, 'GetCashITCBalance'
      key :tags, ['ledger']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ledger
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

  def cash_itc_balance
    ledger = Gsp::Ledger.new(@@gsp_api)
    response = ledger.cash_itc_balance(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/ledger/liability_ledger_return_liability' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get Liability Ledger Details For Return Liability'
      key :operationId, 'GetLiabilityLedgerDetailsForReturnLiability'
      key :tags, ['ledger']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ledger
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

  def liability_ledger_return_liability
    ledger = Gsp::Ledger.new(@@gsp_api)
    response = ledger.liability_ledger_return_liability(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/ledger/retliab_balance' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get RetLiab Balance'
      key :operationId, 'GetRetLiabBalance'
      key :tags, ['ledger']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ledger
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :RetliabBalanceModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :RetliabBalanceModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def retliab_balance
    ledger = Gsp::Ledger.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:action, :ret_type]))
    response = ledger.retliab_balance(@data)
    render json: response, status: :ok
  end

  protected
  def select_hash_date_ledger_values(params)
    data = select_hash_values(params,
                              [:from_date, :to_date],
                              {from_date: :fr_dt, to_date: :to_dt}
                             )
  end

end
