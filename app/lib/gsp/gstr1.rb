#Extensions for the base api that allow authenticated calls
class Gsp::Gstr1
  include SelectHashValues
  include MakeAuthenticateGstnRequests

  URL = '/taxpayerapi/v1.1/returns/gstr1'.freeze

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

  # GSTR1 - Get B2B Invoices GSTR1
  def B2B_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ctin,
                                                  :from_time])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2B',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def CDNR_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :from_time,
                                                  :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def B2BA_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2BA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def CDNRA_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :action_required])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNRA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def B2CL_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :state_cd])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2CL',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def B2CLA_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :state_cd])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2CLA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def B2CSA_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :state_cd])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2CSA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def B2CS_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period, :state_cd])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'B2CS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def CDNURA_invoices(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNURA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

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

  def exp(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'EXP',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def expa(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'EXPA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def at(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'AT',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def ata(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'ATA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def hsn_summary(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'HSNSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def txp(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TXP',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def txpa(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'TXPA',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end



  #This API will call CDNUR for getting all Credit/Debit notes for Unregistered Users.
  def cdnur(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'CDNUR',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #This API calls to get Documents issued during the tax period.
  def doc_issued(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'DOCISS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  #This API is called with the file_num to get the file URL
  def file_details(data)
    query_params_hash = select_hash_values(data, [:ret_period, :token])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'FILEDET',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def file_gstr1(payload)
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

  # GSTR1 - Get Return Status
  def return_status(data)
    query_params_hash = select_hash_values(data, [:ret_period, :ref_id])
    url = '/taxpayerapi/v1.1/returns'
    make_authenticate_gstn_request(url,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSTATUS',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  # GSTR1 - Get GSTR1 summary GSTR1
  def gstr1_summary(data)
    query_params_hash = select_hash_values(data, [:ret_period])
    make_authenticate_gstn_request(URL,
                                   query_params_hash: query_params_hash,
                                   action: 'RETSUM',
                                   method: 'get',
                                   data: data,
                                   return_period: data[:ret_period]
                                  )
  end

  def submit_gstr1(payload)
    data = payload[:data]
    make_authenticate_gstn_request(URL,
                                   action: 'RETSUBMIT',
                                   method: 'post',
                                   data: data,
                                   return_period: payload[:ret_period]
                                  )
  end

end
