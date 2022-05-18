module MakeAuthenticateEwayRequests

  def initialize(eway_api)
    @@eway_api = eway_api
  end

  def make_authenticate_eway_request(path,
                                     query_params_hash: {},
                                     action: nil,
                                     method:,
                                     data:,
                                     gstin: nil
                                    )
    url = path
    headers = (gstin.present?) ? {gstin: gstin} : {}
    @@eway_api.eway_request(url,
                            {
                              data: data
                            },
                            action: action,
                            method: method,
                            headers: headers
                           )
  end

end
