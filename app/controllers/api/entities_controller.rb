class Api::EntitiesController < Api::SubscriptionActiveController
  include Swagger::Blocks
  before_action :set_entity, only: [:show, :update, :destroy]
  load_and_authorize_resource except: [:create, :new]

  respond_to :json

  swagger_path '/api/entities' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'List All Entities'
      key :operationId, 'listEntities'
      key :tags, ['entities']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Entity
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end

    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Create Entity'
      key :operationId, 'createEntity'
      key :tags, ['entities']
      parameter do
        key :name, :entity
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Entity
        end
      end
      response 200 do
        schema do
          key :'$ref', :Entity
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /entities
  # GET /entities.json
  def index
    @entities = Entity.where(common_query).accessible_by(current_ability)
    @entities = @entities.map { |e| e.to_builder.attributes! }
    render json: @entities, status: :ok
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity = Entity.new(entity_params)
    @entity.domain_id = params[:domain_id]
    if @entity.save
      render json: @entity, status: :created
    else
      render json: @entity.errors, status: :unprocessable_entity
    end
  end
  
  swagger_path '/api/domains/{domain_id}/entities' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'List All Entities For Domain'
      key :operationId, 'listEntitiesByDomain'
      key :tags, ['entities']
      parameter do
        key :name, :domain_id
        key :in, :path
        key :description, 'Domain ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Entity
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end


  swagger_path '/api/entities/{id}' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Show Entity'
      key :operationId, 'showEntity'
      key :tags, ['entities']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Entity ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :'$ref', :Entity
        end
      end
      response :unauthorized
      response :not_acceptable
    end

    operation :delete do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Remove Entity'
      key :operationId, 'deleteEntity'
      key :tags, ['entities']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Entity ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200
      response :unauthorized
      response :not_acceptable
    end

    operation :put do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Update Entity'
      key :operationId, 'updateEntity'
      key :tags, ['entities']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Entity ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :entity
        key :in, :body
        key :description, 'Update Entity Value'
        schema do
          key :'$ref', :Entity
        end
      end
      response 200 do
        schema do
          key :'$ref', :Entity
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
    @entity = @entity.to_builder.attributes!
    render json: @entity, status: :ok
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    if @entity.update(entity_params)
      render json: @entity, status: :ok
    else
      render json: @entity.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @entity.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:company_name, :address, :pan_number)
    end

    def common_query
      params[:domain_id].present? ? {domain_id: params[:domain_id]} : {}
    end
    
end
