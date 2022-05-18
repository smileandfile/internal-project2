module ApplicationHelper
  def current_react_token
    current_user.current_react_token
  end

  def server_date
    Date.today.to_s
  end

  def server_time
    Time.now.strftime("%I:%M%p").to_s
  end

  def format_date_for_display(date)
    date.strftime("%Y-%m-%d %H:%M:%S:%L") unless date.nil?
  end

  def format_date(date)
    date.strftime("%Y-%m-%d") unless date.nil?
  end

  def two_decimal_number(value)
    '%.2f' % value
  end

  def snf_setting
    @snf_setting = SnfSetting.first
  end


  def current_gstin
    gstin_id  = session[:current_gstin]
    @gstin = Gstin.find(gstin_id).gstin_number unless gstin_id.nil?
  end

  def show_footer
    true
  end

  def excel_templates
    Upload.excels
  end

  def other_templates
    Upload.others
  end

end
