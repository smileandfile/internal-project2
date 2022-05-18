class Dashboard::AuditController < Dashboard::DashboardController
  load_and_authorize_resource class: GstAccessItem
  load_and_authorize_resource class: CommonApiLog

  def index
    @gst_access_items = GstAccessItem.accessible_by(current_ability)
                          .order('requested_at DESC')
                          .paginate(page: params[:page], per_page: 30)                                
  end

  def common_api
    @gst_access_items = CommonApiLog.accessible_by(current_ability)
                          .order('requested_at DESC')
                          .paginate(page: params[:page], per_page: 30)                                
  end

  def eway_api
    @gst_access_items = EwayApiLog.includes([:eway_bill_user]).accessible_by(current_ability)
                          .order('requested_at DESC')
                          .paginate(page: params[:page], per_page: 30)    
  end

end
