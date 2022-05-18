
#Extensions for the base api that allow authenticated calls
class Gsp::Gstr3b
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v0.3/returns/gstr3b'.freeze

  def save_gstr3b(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSAVE',
                                   method: 'put',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )

  end

  def get_gstr3b_details(payload)
    query_params_hash = select_hash_values(payload, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: payload,
                                   return_period: payload[:ret_period]
                                  )
                                          
  end

  def track_status(payload)
    url ='/taxpayerapi/v0.3/returns'
    query_params_hash = select_hash_values(payload, [:ret_period, :ref_id])
    make_authenticate_gstn_request(url,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSTATUS',
                                   method: 'get',
                                   data: payload,
                                   return_period: payload[:ret_period]
                                  )
  end

  def submit_gstr3b(payload)
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: payload,
                                   return_period: payload[:ret_period]
                                  )
  end
  
  def offset_liability_gstr3b(payload)
    data = payload[:data]
    @@gsp_api.authenticated_gstn_request(URL,
    {
      data: data
    },
    {action: 'RETOFFSET',
    method: 'put',
    headers: { ret_period: payload[:ret_period]}},
    true, true, false
   )
  end

  def file_gstr3b(payload)
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





end
