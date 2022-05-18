class Api::RolesController < Api::ApiController
  include Swagger::Blocks

  swagger_path '/api/roles' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Fetch All Roles'
      key :operationId, 'listRoles'
      key :tags, ['Roles']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Role
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def index
    @roles = current_user.accessed_roles
    render json: @roles, status: :ok
  end
end
