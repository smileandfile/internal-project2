require 'exceptions'

class Api::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  before_action :prepare_exception_notifier
  before_action :set_notification


  rescue_from CanCan::AccessDenied do |exception|
    puts "CANCAN ACCESSDENIED #{exception.message}"
    render json: {msg: exception.message}, status: :not_found
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: :not_found
  end

  rescue_from GstnUpstreamException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message, upstream_headers: exception.upstream_headers}, status: response.code
  end

  rescue_from EwayBillUpstreamException do |exception|
    print_logger_message(exception)
    render json: {message: exception.message, upstream_headers: exception.upstream_headers}, status: response.code
  end

  rescue_from NotValidEwayBillUserException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: :unauthorized
  end

  rescue_from EwayBillGstinNilException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: response.code
  end

  rescue_from AuthTokenExpiredException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: :unauthorized
  end


  rescue_from GstnAspException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: :bad_request
  end

  rescue_from GstnUpstreamConnectionError do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message, upstream_headers: exception.upstream_headers}, status: response["response_cd"]
  end

  rescue_from RoleCheckFailedException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message}, status: :forbidden
  end

  rescue_from GstnAuthenticationFailedException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message, upstream_headers: exception.upstream_headers}, status: :unauthorized
  end

  rescue_from Net::HTTPServerException do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message, upstream_headers: exception.response.to_hash}, status: exception.response.code
  end

  rescue_from SslDecryptionError do |exception|
    print_logger_message(exception)
    render json: {msg: exception.message, upstream_headers: exception.upstream_headers}, status: response.code
  end
  
  def print_logger_message(exception)
    Rails.logger.warn exception.message
    exception.backtrace.each { |line| logger.error line }
  end
  

  def self.set_gstn_access_headers(api)
    api.param :header, 'access-token', :string, :required
    api.param :header, 'token-type', :string, :required
    api.param :header, 'client', :string, :required
    api.param :header, 'expiry', :string, :required
    api.param :header, 'uid', :string, :required
    api.param :header, 'gstin-id', :string, :required if gstin_id_header_required?
  end

  def self.gstin_id_header_required?
    false
  end
end
