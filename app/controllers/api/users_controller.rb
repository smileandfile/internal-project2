class Api::UsersController < Api::SubscriptionActiveController
  include Swagger::Blocks
  before_action :set_user, only: [:show, :update, :destroy, :edit]
  load_and_authorize_resource except: [:index]

  respond_to :json

  swagger_path '/api/domains/{domain_id}/users' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'List Users'
      key :operationId, 'listUsers'
      key :tags, ['user']
      parameter do
        key :name, :domain_id
        key :in, :path
        key :description, 'domain id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :User
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def index
    @users = User.where(common_query).includes(:gstins, :roles, :entities)
    render json: @users.map { |u| u.to_builder.attributes! }
  end

  swagger_path '/api/domains/{domain_id}/users/{id}' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Show User'
      key :operationId, 'showUser'
      key :tags, ['user']
      parameter do
        key :name, :domain_id
        key :in, :path
        key :description, 'domain id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'User id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :'$ref', :User
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /domains/:domain_id/users/:id
  def show
    render json: @user.to_builder.attributes!, status: :ok
  end

  # PUT /domains/:domain_id/users/:id
  def update
    if @user.update(user_params)
      render json: @user.to_builder.attributes!, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.where(common_query).find(params[:id])
  end

  def common_query
    {domain_id: params[:domain_id]}
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :phone_number, entity_ids: [], gstin_ids: [],
                                  branch_ids: [], role_ids: [])
  end
end
