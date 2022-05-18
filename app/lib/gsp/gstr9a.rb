class Gsp::Gstr9a
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v1.1/returns/gstr9a'.freeze #wrong url provided on developer.gst.gov.in for gstr9 and 9a

  def file_gstr9a(payload)
    url = '/taxpayerapi/v1.1/returns/gstr'.freeze
    file_gstr(url: url,
              action: 'RETFILE',
              method: 'post',
              body: { 
                      data: payload[:data],
                      sign: payload[:pkcs7_data],
                      st: payload[:st],
                      sid: payload[:sid],
                    },
              return_period: payload[:return_period],
              api_version: "1.1",
              rtn_typ: "GSTR9a",
              userrole: "GSTR9a"
              )
  end

  def file_details(data)
    query_params_hash = select_hash_values(data, [:ret_period])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RECORDS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period],
                                   api_version: "1.1",
                                   rtn_typ: "GSTR9a",
                                   userrole: "GSTR9a"
                                  )
  end

  def save_data(data)
    make_authenticate_gstn_request(URL,
                                   data: data[:data],
                                   action: 'RETSAVE',
                                   method: 'put',
                                   return_period: data[:fp],
                                   rtn_typ: 'GSTR9a',
                                   api_version: '1.1',
                                   userrole: 'GSTR9a'
                                  )
  end

  def calculate_details(data)
    query_params_hash = select_hash_values(data, [:ret_period])                                        
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CALRCDS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period],
                                   api_version: "1.1",
                                   rtn_typ: "GSTR9a",
                                   userrole: "GSTR9a"
                                  )
  end

end