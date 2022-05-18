#Extensions for the base api that allow authenticated calls
class Gsp::EwayBill
  include MakeAuthenticateEwayRequests



  def retrieve_bill(data)
    url = "/ewayapi/GetEwayBill?ewbNo=#{data[:bill_number]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )
  end

  def eway_bils_transporter(data)
    url = "/ewayapi/GetEwayBillsForTransporter?date=#{data[:date]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )
    end

  def eway_bils_transporter_by_gstin(data)
    url = "/ewayapi/GetEwayBillsForTransporterByGstin?Gen_gstin=#{data[:gen_gstin]}&date=#{data[:date]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )
  end

  def eway_bils_generated_by_others(data)
    url = "/ewayapi/GetEwayBillsofOtherParty?date=#{data[:date]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )
  end
    
  def cons_eway_bills(data)
    url = "/ewayapi/GetTripSheet?tripSheetNo=#{data[:trip_sheet_number]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )
  end


  def generate_eway_bill(body)
    Rails.logger.info "params data *** #{body[:data]}"
    Rails.logger.info "params gstin *** #{body[:gstin]}"
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "GENEWAYBILL",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def update_vehicle_number(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "VEHEWB",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def cancel_eway_bill(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "CANEWB",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def reject_eway_bill(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "REJEWB",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def generate_consolidated_eway_bill(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "GENCEWB",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end
  def update_transporter(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "UPDATETRANSPORTER",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end
  def extend_validity(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "EXTENDVALIDITY",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end
  def regenerate_consolidated_eway_bill(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "REGENTRIPSHEET",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def gstin_detail(data)
    url = "/Master/GetGSTINDetails?GSTIN=#{data[:gstin_number]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )

  end
  def transporter_detail(data)
    url = "/Master/GetTransporterDetails?trn_no=#{data[:trn_no]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )

  end
  def error_list(data)
    url = "/Master/GetErrorList"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )

  end
  def hsn_code_detail(data)
    url = "/Master/GetHsnDetailsByHsnCode?hsncode=#{data[:hsn_code]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin]
                                  )

  end

  def multi_vehicle_movement_initiation(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "MULTIVEHMOVINT",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def multi_vehicle_add(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "MULTIVEHADD",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def multi_vehicle_update(body)
    url = "/ewayapi/"
    make_authenticate_eway_request(url,
                                   action: "MULTIVEHUPD",
                                   method: 'post',
                                   data: body[:data],
                                   gstin: body[:gstin]
                                  )
  end

  def bill_generated_by_consigner(data)
    url = "/ewayapi/GetEwayBillGeneratedByConsigner?docType=#{data[:docType]}&docNo=#{data[:docNo]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin] 
                                  )
  end

  def eway_bill_for_transporter_by_state data 
    url = "/ewayapi/GetEwayBillsForTransporterByState?date=#{data[:date]}&stateCode=#{data[:state_code]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin] 
                                  )
  end

  def ewaybill_by_date data
    url = "/ewayapi/GetEwayBillsByDate?date=#{data[:date]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin] 
                                  )
  end

  def ewaybill_rejected_by_others data 
    url = "/ewayapi/GetEwayBillsRejectedByOthers?date=#{data[:date]}"
    make_authenticate_eway_request(url,
                                   action: nil,
                                   method: 'get',
                                   data: data,
                                   gstin: data[:gstin] 
                                  )
  end

end
