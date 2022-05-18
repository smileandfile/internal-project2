class Users::PasswordsController < Devise::PasswordsController
  layout 'authentication'
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    #We are finding user manually because its super class finding on the basis
    # of only email address
    resource_class = User.find_for_authentication(resource_params)  
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource_class if block_given?
    if successfully_sent?(resource_class)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource_class)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

end
