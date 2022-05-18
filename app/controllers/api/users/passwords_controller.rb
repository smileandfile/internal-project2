class Api::Users::PasswordsController < DeviseTokenAuth::PasswordsController
  include Swagger::Blocks

  swagger_schema :PasswordModel do
    key :required, [:email]
    property :email  do
      key :type, :string
    end
  end

  swagger_schema :UpdatePasswordModel do
    key :required, [:password, :password_confirmation]
    property :password  do
      key :type, :string
    end
    property :password_confirmation  do
      key :type, :string
    end
  end
  # GET /resource/password/new
  # def new
  #   super
  # end


  swagger_path '/api/users/password' do
    operation :post do
      key :description, "forget your password"
      key :operationId, 'forgetPassword'
      key :tags, ['passwords']
      parameter do
        key :name, :email
        key :in, :body
        key :description, 'Email Address'
        key :required, true
        key :type, :string
        schema do
          key :'$ref', :PasswordModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :PasswordModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end


  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  swagger_path '/api/users/password' do
    operation :put do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "update your password"
      key :operationId, 'updatePassword'
      key :tags, ['passwords']
      parameter do
        key :name, :password
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :UpdatePasswordModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :UpdatePasswordModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end


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
