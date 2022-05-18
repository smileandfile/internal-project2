class Api::SubscriptionActiveController < Api::WorkingLevelController
  include RoleChecker

  before_action :check_roles
  before_action :check_email_verified
  before_action :check_phone_verified
  before_action :check_subcription_active

  def check_subcription_active
    msg = 'Please choose a subscription package from the options available.'
    render json: {msg: msg}, status: :failed_dependency unless
      current_user&.has_active_package?
  end

  def check_email_verified
    msg = "Please verify your email address first. Please check your inbox for instructions."
    render json: {msg: msg}, status: :failed_dependency unless
      current_user&.email_confirmed?
  end

  def check_phone_verified
    msg = "Please verify your Phone Number"
    render json: {msg: msg}, status: :failed_dependency unless
      current_user&.phone_confirmed?
  end
end

