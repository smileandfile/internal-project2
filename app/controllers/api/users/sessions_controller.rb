class Api::Users::SessionsController < DeviseTokenAuth::SessionsController
  include Swagger::Blocks
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  swagger_schema :SigninModel do
    key :required, [:email, :password, :domain_name]
    property :email  do
      key :type, :string
    end
    property :password  do
      key :type, :string
    end
    property :domain_name  do
      key :type, :string
    end
  end

  swagger_path '/api/users/sign_in' do
    operation :post do
      key :description, 'Sign In'
      key :operationId, 'createSession'
      key :tags, ['Sign In']
      parameter do
        key :name, :user
        key :in, :body
        key :type, :string
        key :description, 'User details'
        schema do
          key :'$ref', :SigninModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :SigninModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # POST /resource/sign_in
  def create
    # below copied from superclass
    @resource = User.find_for_authentication(resource_params.dup.reject!{ |k| k.to_sym == :password })  
    
    if @resource && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
        render_create_error_bad_credentials
        return
      end
      # create client id
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token     = SecureRandom.urlsafe_base64(nil, false)

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }
      @resource.save

      sign_in(:user, @resource, store: false, bypass: false)

      yield @resource if block_given?

      render_create_success
    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      render_create_error_not_confirmed
    else
      render_create_error_bad_credentials
    end
  end

  swagger_path '/api/users/sign_out' do
    operation :delete do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Sign Out'
      key :operationId, 'destroySession'
      key :tags, ['Sign In']
      response 200
      response :unauthorized
      response :not_acceptable
    end
  end


  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  def render_new_error
    error= {message: "Domain invalid"}
    return render json: error
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :domain_name])
  end
end
