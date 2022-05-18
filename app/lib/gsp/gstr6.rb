#Extensions for the base api that allow authenticated calls
class Gsp::Gstr6
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr6'.freeze

  def save_invoices(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSAVE',
                                   method: 'put',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

  def offset_late_fee(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'SETOFFCASH',
                                   method: 'put',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end


  def b2b_invoices(data)
    callApiwithMultipleQueryParams(data, 'B2B')
  end


  def cdn_invoices(data)
    callApiwithMultipleQueryParams(data, 'B2B')
  end

  def isd_details
    callApiwithReturnPeriodQuery(data, 'ISD')
  end

  def summary(data)
    callApiwithReturnPeriodQuery(data, 'RETSUM')
  end

  def late_fee(data)
    callApiwithReturnPeriodQuery(data, 'LATEFEE')
  end

  def itc_details(data)
    callApiwithReturnPeriodQuery(data, 'ITC')
  end

  def mismatch_details(data)
    callApiwithReturnPeriodQuery(data, 'MISMATCH')
  end

  def refund_claim(data)
    callApiwithReturnPeriodQuery(data, 'REFCLM')
  end


  def submit(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end
  
  def submit_refund_claim(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'SUBMITREFCLM',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end



  def file_gstr6(payload)
    file_gstr(url: URL,
              action: 'RETFILE',
              method: 'post',
              body: { 
                      data: payload[:data],
                      sign: payload[:pkcs7_data],
                      st: payload[:st],
                      sid: payload[:sid]
                    },
              return_period: payload[:return_period])
  end

  
  #[:ret_period, :ctin,:action_required, :from_time]
  def callApiwithMultipleQueryParams(data, action)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :action_required, :from_time])
    make_authenticate_gstn_request(URL,
    query_params_hash: query_params_hash,
    action: action,
    method: 'get',
    data: data,
    return_period: data[:ret_period]
    )
  end

  def callApiwithReturnPeriodQuery(data, action)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                    query_params_hash: query_params_hash,
                                    action: action,
                                    method: 'get',
                                    data: data,
                                    return_period: data[:ret_period]
                                  )
  end

end
