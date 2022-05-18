#Extensions for the base api that allow authenticated calls
class Gsp::Gstr4
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr4'.freeze


  def b2ba(data)
    callApiwithReturnPeriodQuery(data, 'B2BA')
  end
  def b2b_unregistered_amendment(data)
    callApiwithReturnPeriodQuery(data, 'B2BURA')
  end
  def cdnr_amendment(data)
    callApiwithReturnPeriodQuery(data, 'CDNRA')
  end
  def cdnur_amendment(data)
    callApiwithReturnPeriodQuery(data, 'CDNURA')
  end
  def imps_amendment(data)
    callApiwithReturnPeriodQuery(data, 'IMPSA')
  end
  def advance_paid_amendment(data)
    callApiwithReturnPeriodQuery(data, 'ATA')
  end
  def advances_adjusted_amendment(data)
    callApiwithReturnPeriodQuery(data, 'UCOD')
  end



  # GSTR4 - Save GSTR4
  def save_invoices(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSAVE',
                                   method: 'put',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end



  # GSTR1 - Get B2B Invoices GSTR1
  def B2B_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2B',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def b2b_unregistered_invoice(data)
    callApiwithReturnPeriodQuery(data, 'B2BUR')
  end

  def import_of_services(data)
    callApiwithReturnPeriodQuery(data, 'IMPS')
  end

  def cdnr_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period,
                                                  :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #This API will call CDNUR for getting all Credit/Debit notes for Unregistered Users.
  def cdnur(data)
    callApiwithReturnPeriodQuery(data, 'CDNUR')
  end
  
  def tax_on_outward_supplies(data)
    callApiwithReturnPeriodQuery(data, 'TXOS')
  end

  def advances_paid(data)
    callApiwithReturnPeriodQuery(data, 'AT')
  end

  def advances_adjusted(data)
    callApiwithReturnPeriodQuery(data, 'TXP')
  end

  def summary(data)
    callApiwithReturnPeriodQuery(data, 'RETSUM')
  end
  def tds(data)
    callApiwithReturnPeriodQuery(data, 'TDS')
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

  def file_gstr4(payload)
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

  def set_off_liability(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'SETOFF',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
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
