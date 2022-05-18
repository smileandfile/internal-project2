
#Extensions for the base api that allow authenticated calls
class Gsp::Ledger 
  include SelectHashValues
  include MakeAuthenticateGstnRequests
  attr_accessor :username

  URL = '/taxpayerapi/v0.3/ledgers'.freeze

  def cash_ledger(data)
    query_params_hash = select_hash_values(data, [:fr_dt, :to_dt])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CASH',
                                   method: 'get',
                                   data: data
                                  )
  end

  def itc_ledger(data)
    query_params_hash = select_hash_values(data, [:fr_dt, :to_dt])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'ITC',
                                   method: 'get',
                                   data: data
                                  )
  end

  #Get Liability Ledger Details For Return Liability
  def liability_ledger_return_liability(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TAX',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #pending
  #This API is to get the Return Related Liability Balance for the user for the tax period
  def retliab_balance(data)
    query_params_hash = select_hash_values(data, [:ret_period, 
                                                  :ret_type, 
                                                  :action])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TAXPAYABLE',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #Cash ITC Balance
  def cash_itc_balance(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'BAL',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

end
