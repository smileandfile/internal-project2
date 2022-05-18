class Users::SessionsController < Devise::SessionsController
  layout 'authentication'
  # GET /resource/sign_in
  # def new
  #   super
  # end

  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      return redirect_to new_user_session_path
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :domain_name])
  end
end
