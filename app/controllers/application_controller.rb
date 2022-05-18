class ApplicationController < ActionController::Base

  CHECK_WORKING_LEVEL = false

  def initialize
    super
    @signzy_esigner = ::SignzyEsigner.new
  end

  def signzy_esign_data(payload)
    encoded_data = Digest::SHA256.hexdigest payload[:data].to_json
    signzy_response = @signzy_esigner.hash_sign(aadhaar_number: payload[:aadhaar_number], otp: payload[:aadhaar_otp], hash: encoded_data)
  end


  def get_return_period
    @data = select_hash_values(params,
                               [:return_period],
                               {return_period: :ret_period}
                              )
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    puts "CANCAN ACCESSDENIED #{exception.message}"
    redirect_to main_app.root_path
  end

  def set_notification
    request.env['exception_notifier.exception_data'] = {"server" => request.env['SERVER_NAME']}
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      :current_user => current_user
    }
  end


end
