class Gsp::Gstr9c
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v1.1/returns/gstr9c'.freeze

  def generate_certi data
    make_authenticate_gstn_request(URL,
                                   data: data,
                                   action: 'RETGENCERT',
                                   method: 'put'
                                  )
  end

  def summary data
    make_authenticate_gstn_request(URL,
                                   query_params_hash: data,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def file_gstr9c data
    make_authenticate_gstn_request(URL,
                                   action: 'RETFILE',
                                   method: 'post',
                                   data: data
                                  )
  end

  def gstr9_records data 
    make_authenticate_gstn_request(URL,
                                   query_params_hash: data,
                                   action: 'RECDS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def save_gstr9c data
    make_authenticate_gstn_request(URL,
                                   data: data,
                                   action: 'RETSAVE',
                                   method: 'put',
                                   return_period: data[:gstr9cdata]['audited_data']['fp'],
                                   api_version: "1.1",
                                   rtn_typ: "GSTR9c",
                                   userrole: "GSTR9c"
                                  )
  end

  def hash_generator data
    make_authenticate_gstn_request(URL,
                                   data: data,
                                   action: 'RETGENHASH',
                                   method: 'put',
                                   return_period: data[:gstr9cdata]['audited_data']['fp'],
                                   api_version: "1.1",
                                   rtn_typ: "GSTR9c",
                                   userrole: "GSTR9c"
                                  )
  end

end