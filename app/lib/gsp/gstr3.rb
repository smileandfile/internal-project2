#Extensions for the base api that allow authenticated calls
class Gsp::Gstr3
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr3'.freeze

  #GSTR3 - Save GSTR3
  def save_gstr3(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSAVE',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

  # GSTR3 - gstr3_details
  def gstr3_details(data)
    query_params_hash = select_hash_values(data, [:ret_period, :final])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR3 - generate_gstr3
  def generate_gstr3(data)
    query_params_hash = select_hash_values(data, [:ret_period])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'GENERATE',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR3 - file_gstr3
  def file_gstr3(payload)
    file_gstr(url: URL,
              action: 'RETFILE',
              method: 'post',
              body: { 
                      data: payload[:data].as_json,
                      sign: payload[:pkcs7_data],
                      st: payload[:st],
                      sid: payload[:sid]
                    },
              return_period: payload[:return_period])
  end

  # GSTR3 - Get Return Status
  def return_status(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ref_id])
    url = '/taxpayerapi/v0.3/returns'
    make_authenticate_gstn_request(url,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSTATUS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR3 - Submit Liabilities And Interest
  def submit_liabilities_and_interest(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETACCEPT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

  # GSTR3 - Setoff Liability
  def setoff_liability(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETOFFSET',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

  # GSTR3 - Submit Refund
  def submit_refund(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

end
