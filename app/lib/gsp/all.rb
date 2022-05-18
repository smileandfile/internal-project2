#Extensions for the base api that allow authenticated calls
class Gsp::All
  include SelectHashValues
  include MakeAuthenticateGstnRequests
  attr_accessor :username

  URL = '/taxpayerapi/v0.3/returns'.freeze

  #This API is called with the file_num to get the file URL
  def file_details(data)
    url = '/taxpayerapi/v1.1/returns'

    query_params_hash = select_hash_values(data, [:ret_period, :token])
    make_authenticate_gstn_request(url,
                                   query_params_hash: query_params_hash,
                                   action: 'FILEDET',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period])
  end

  def view_track_return_status(data)
    query_params_hash = select_hash_values(data, [:ret_period, :type])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETTRACK',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period])
  end

  def download_doc data
    url = '/taxpayerapi/v1.0/returns'
    query_params_hash = select_hash_values(data, [:doc_id], {doc_id: :id})
    make_authenticate_gstn_request(url,
                                   query_params_hash: query_params_hash,
                                   action: 'DOCDWLD',
                                   method: 'get',
                                   data: data) 
  end

  def upload_doc data
    url = '/taxpayerapi/v1.0/returns'
    make_authenticate_gstn_request(url,
                                   action: 'DOCUPLD',
                                   method: 'post',
                                   data: data)
  end

  def late_fee data
    url = '/taxpayerapi/v1.0/returns/gstr'
    make_authenticate_gstn_request(url,
                                   query_params_hash: data,
                                   action: 'LATEFEE',
                                   method: 'get',
                                   data: data)
  end

  def doc_status data
    url = '/taxpayerapi/v1.1/document'
    make_authenticate_gstn_request(url,
                                   query_params_hash: data,
                                   action: 'DOCSTATUS',
                                   method: 'get',
                                   data: data)
  end

  def proceed_to_file data
    url = '/taxpayerapi/v1.1/returns/gstr'
    make_authenticate_gstn_request(url,
                                   action: 'PROCEEDFILE',
                                   method: 'post',
                                   data: data)
  end

end
