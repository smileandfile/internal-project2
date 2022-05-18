module MakeAuthenticateGstnRequests

  def initialize(gsp_api)
    @@gsp_api = gsp_api
  end

  def make_query_params(data)
    data[:gstin] = @@gsp_api.gstin
    data.to_query
  end

  def make_authenticate_gstn_request(path,
                                     query_params_hash: {},
                                     action: nil,
                                     method:,
                                     data:,
                                     return_period: nil,
                                     api_version: nil,
                                     rtn_typ: nil,
                                     userrole: nil
                                    )
    query_params = make_query_params(query_params_hash) if method == 'get'
    url = (method == 'get') ? (path + '?' + query_params) : path
    headers = {}
    header_in_body = false
    if rtn_typ.present? && userrole.present? && api_version.present? && return_period.present? 
      headers = {rtn_typ: rtn_typ, userrole: userrole, api_version: api_version, ret_period: return_period}
      header_in_body = true
    elsif return_period.present?
      headers = { ret_period: return_period }
    end
    @@gsp_api.authenticated_gstn_request(url,
                                         {
                                           data: data
                                         },
                                         {
                                            action: action,
                                            method: method,
                                            headers: headers
                                         },
                                         header_in_body
                                        )
  end

  def make_dsc_request(path,
                       query_params_hash: {},
                       action: nil,
                       method:,
                       data:,
                       return_period: nil
                      )
    query_params = make_query_params(query_params_hash) if method == 'get'
    headers = (return_period.present?) ? {ret_period: return_period} : {}
    @@gsp_api.authenticated_dsc_request(path,
                                         {
                                           data: data
                                         },
                                         action: action,
                                         method: method,
                                         headers: headers
                                        )
  end

  def file_gstr(url:,
                action: nil,
                method:,
                body:,
                return_period: nil,
                api_version: nil,
                rtn_typ: nil,
                userrole: nil)
    header_in_body = false
    if (rtn_typ.present? && userrole.present? && api_version.present?)
      headers = {rtn_typ: rtn_typ, userrole: userrole, api_version: api_version, ret_period: return_period}
      header_in_body = true
    else
      headers = {ret_period: return_period}
    end
    @@gsp_api.authenticated_gstn_request(url,
                                         body,
                                         {
                                         action: action,
                                         method: method,
                                         headers: headers
                                         }, header_in_body, false, true
                                        )
                

  end




end
