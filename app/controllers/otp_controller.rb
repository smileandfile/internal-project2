class OtpController < Dashboard::BaseDashboardController
  before_action :check_and_set_type_param, only: [:validate, :generate]

  def authenticate
  end

  def generate
    @success = if @type == :mobile
                 current_user.send_otp_mobile
               elsif @type == :email
                 current_user.send_otp_email
               else
                 false
               end

    @message = if @success
                 @type == :mobile ? '' : 'The email may be in Junk / Spam folder. Please check.'
               else
                 'Unable to send OTP. Please check your ' \
                 + (@type == :mobile ? 'Phone Number' : 'Email')
               end
  end

  def validate
    otp = params[:otp]

    @success = if @type == :mobile
                 current_user.authenticate_otp(otp, drift: 120)
               elsif @type == :email
                 current_user.authenticate_otp_email(otp)
               else
                 false
               end

    @fully_validated = current_user.both_otps_validated?
    @message = if @success
                 "Successfully validated OTP on #{@type.capitalize}."
               else
                 'OTP validation failed. Please try again!'
               end
  end
  
  def validate_user
  end

  private

  def check_and_set_type_param
    @type = params[:type]
    @type = @type.to_sym if @type.present?
    render status: :bad_request unless @type.present? && %i[email mobile].include?(@type)
  end
end
