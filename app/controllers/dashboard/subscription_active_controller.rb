class Dashboard::SubscriptionActiveController < Dashboard::BaseDashboardController
  before_action :check_email_verified
  before_action :check_phone_verified
  before_action :check_subcription_active

  protected
  def check_subcription_active
    notice = 'Please choose a subscription package from the options available.'
    redirect_to dashboard_packages_path, notice: notice unless current_user&.has_active_package?
  end

  def check_email_verified
    if current_user&.user? && !current_user&.email_confirmed?
      notice = "Please verify your email address first."
      redirect_to validate_user_path, notice: notice
    else
      notice = 'Please verify your email address first. We have mailed you please check your inbox.'
      redirect_to create_access_request_new_dashboard_domains_path, notice: notice unless current_user&.email_confirmed?
    end  
  end

  def check_phone_verified
    if current_user&.user? && !current_user&.email_confirmed?
      notice = "Please verify your email address first."
      redirect_to validate_user_path, notice: notice
    else
      redirect_to create_access_request_new_dashboard_domains_path, notice: 'Please verify your Phone Number' unless
        current_user&.phone_confirmed?
    end  
  end
end
