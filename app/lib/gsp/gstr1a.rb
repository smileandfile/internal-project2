#Extensions for the base api that allow authenticated calls
class Gsp::Gstr1a
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr1a'.freeze

 
  # GSTR1 - Save GSTR1
  def save_invoices(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSAVE',
                                   method: 'put',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end



  # GSTR1a - Get B2B Invoices GSTR1a
  def b2b_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :from_time, :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2B',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def cdnr_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :from_time,
                                                  :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def b2ba_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :action_required, :ctin])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2BA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def cdnra_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNRA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

 
  # GSTR1a - Get GSTR1 summary GSTR1a
  def gstr1a_summary(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end


  def file_gstr1a(payload)
        file_gstr(url: URL,
              action: 'RETFILE',
              method: 'post',
              body: { 
                      data: payload[:data],
                      sign: payload[:pkcs7_data],
                      st: payload[:st],
                      sid: payload[:sid],
                    },
              return_period: payload[:return_period])
  end


  def submit_gstr1a(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end



end
