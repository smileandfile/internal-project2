class Gsp::Dsc
  include SelectHashValues
  include MakeAuthenticateGstnRequests
  attr_accessor :username

  URL = '/taxpayerapi/v0.2'.freeze

  # Register a DSC against a GSTIN
  def register(payload)
    data = select_hash_values(payload, [:data, :sign])
    make_dsc_request(URL + '/registerdsc',
                     method: 'post',
                     data: data
                    )
  end

  # Deregister a DSC against a GSTIN
  def deregister(payload)
    data = select_hash_values(payload, [:data, :sign])
    make_dsc_request(URL + '/deregisterdsc',
                     method: 'post',
                     data: data
                    )
  end
end
