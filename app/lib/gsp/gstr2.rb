#Extensions for the base api that allow authenticated calls
class Gsp::Gstr2
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr2'.freeze

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
                                

  # GSTR2 - Get B2B Invoices GSTR2
  def B2B_invoices(data)
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

  def get_import_goods_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'IMPG',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end
  #Get imp of services bills
  def get_import_service_bills(data)
    query_params_hash = select_hash_values(data, [:ret_period])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'IMPS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end
  
  #API call CDN for getting all Credit/Debit notes invoices for a return period.
  def cdn_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :from_time, :action_required])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDN',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #API call for getting Item details related to Tax liability under reverse charge.
  def tax_liability_reverse_charge_summary(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TXLI',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end
  # API call for getting invoice details related to Tax paid under reverse charge.  
  def tax_paid_reverse_charge(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TXP',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #API call for getting invoices related to Nil related for a return period
  def nil_rated(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'NIL',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def file_gstr2(payload)
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

  # API call for getting B2B Unregistered invoices for a return period.
  def b2bur(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2BUR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR2 - Get GSTR2 summary GSTR1
  def gstr2_summary(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR1 - Get B2B Invoices GSTR1
  def cdnur(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :from_time])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNUR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def submit_gstr2(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

  # GSTR2 - Get HSN summary of Inward supplies
  def hsn(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'HSNSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR2 - Get ITC Reversal Details
  def itc_rvsl(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'ITCRVSL',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end
end
