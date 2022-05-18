require 'exceptions'

class Dashboard::GstnBaseController < Dashboard::SubscriptionActiveController
  before_action :check_gstin, except: [:set_gstin, :save_current_session_gstin]
  authorize_resource class: false

  def save_current_session_gstin
     begin
       gstin = Gstin.find(params[:gstin_number])
       session[:current_gstin] = gstin['id'] # this will update the saved session
       month = params[:date][:month]
       if month.length == 1
        month = "0" + month 
       end
       session[:current_return_period] = month + params[:date][:year]
       redirect_to dashboard_gstr3b_index_path, notice: "Your gstin number set to session"
     rescue ActiveRecord::RecordNotFound
        redirect_to set_gstin_dashboard_gstn_base_index_path, notice: "Your gstin not found"
     end
  end

  def set_gstin
    @gstins = Gstin.accessible_by(current_ability)
  end

  def current_gstin
    @gstin = Gstin.find(session[:current_gstin])
    @gstin
  end


  def check_gstin
    if session[:current_gstin].nil?
      return redirect_to set_gstin_dashboard_gstn_base_index_path, notice: 'Select GSTIN for filling gstr3b'
    end
  end

  def check_gst_auth
    @gstin = set_gstin
  end

end
