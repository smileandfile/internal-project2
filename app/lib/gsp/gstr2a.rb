#Extensions for the base api that allow authenticated calls
class Gsp::Gstr2a
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr2a'.freeze

  # GSTR1 - Get B2B Invoices GSTR1
  def B2B_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2B',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def CDN_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDN',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end


  def isd_credit(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin])
    make_authenticate_gstn_request(URL,
    query_params_hash: query_params_hash,
    action: 'ISD',
    method: 'get',
    data: data,
    return_period: data[:ret_period]
    )

  end

end
