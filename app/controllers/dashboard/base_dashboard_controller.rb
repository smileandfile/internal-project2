require 'exceptions';
class Dashboard::BaseDashboardController < ApplicationController

  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :prepare_exception_notifier
  before_action :set_notification

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  layout 'dashboard'


  def record_not_found
    redirect_to dashboard_path, notice: "The page you requested was not found"
  end

  rescue_from CanCan::AccessDenied do |exception|
    puts "CANCAN ACCESSDENIED #{exception.message}"
    redirect_to new_user_session_path
  end

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end


  def check_gstin
    if current_user.present?
      gstin = session[:current_gstin] if session[:current_gstin].present?
      # raise GstnAuthenticationFailedException.new('GSTIN is not set') unless gstin.nil?
    end
  end

  def current_gstin
    # gstin = Gstin.find_with_authorization(session[:current_gstin]) if session[:current_gstin].present?
    gstin = session[:current_gstin] if session[:current_gstin].present?
    gstin ||= current_user.branch.gstin.gstin_number
    if gstin.nil?
     return false
    end
    return true
  end

end
