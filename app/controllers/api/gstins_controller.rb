class Api::GstinsController < Api::SubscriptionActiveController
  include Swagger::Blocks
  before_action :set_gstin, only: [:show, :update, :destroy, :edit]
  load_and_authorize_resource except: [:create, :new]

  respond_to :json

  swagger_path '/api/gstins' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Fetches all Gstins'
      key :operationId, 'listGstins'
      key :tags, ['Gstin']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstin
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
      key :description, 'Create Gstin'
      key :operationId, 'addGstin'
      key :tags, ['Gstin']
      parameter do
        key :name, :entity_id
        key :in, :path
        key :description, 'Entity id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :gstin
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Gstin
        end
      end
      response 200 do
        schema do
          key :'$ref', :Gstin
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  swagger_path '/api/entities/{entity_id}/gstins' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Fetches All GSTINs by Entity'
      key :operationId, 'listGstinsByEntity'
      key :tags, ['Gstin']
      parameter do
        key :name, :entity_id
        key :in, :path
        key :description, 'Entity ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Gstin
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /gstins
  # GET /gstins.json
  def index
    @gstins = Gstin.where(common_query).accessible_by(current_ability)
    @gstins = @gstins.map { |g| g.to_builder.attributes! }
    render json: @gstins, status: :ok
  end

  # POST /gstins
  # POST /gstins.json
  def create
    @gstin = Gstin.new(gstin_params)
    @gstin.entity_id = params[:entity_id]
    if @gstin.save
      render json: @gstin, status: :created
    else
      render json: @gstin.errors, status: :unprocessable_entity
    end
  end

  swagger_path '/api/gstins/{id}' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "Show Gstin"
      key :operstionId, "showGstin"
      key :tags, ['Gstin']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :'$ref', :Gstin
        end
      end
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
      key :description, "Update gstin"
      key :operationId, 'updateGstin'
      key :tags, ['Gstin']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :gstin
        key :in, :body
        key :description, 'Gstin to update'
        key :required, true
        schema do
          key :'$ref', :Gstin
        end
      end
      response 200 do
        schema do
          key :'$ref', :Gstin
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
      key :description, 'Delete Gstin'
      key :operationId, 'deleteGstin'
      key :tags, ['Gstin']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /gstins/1
  # GET /gstins/1.json

  def show
    @gstin= @gstin.to_builder.attributes!
    server_time = Time.now
    unless @gstin['auth_expires_at'].nil?
      actual_time_of_token_expires = @gstin['auth_expires_at'] - server_time
      @gstin.merge!({actual_time_of_token_expires: actual_time_of_token_expires, server_time: server_time})
    end
    render json: @gstin, status: :ok
  end


  # PATCH/PUT /gstins/1
  # PATCH/PUT /gstins/1.json
  def update
    if @gstin.update(gstin_params)
      render json: @gstin, status: :ok
    else
      render json: @gstin.errors, status: :unprocessable_entity
    end
  end


  # DELETE /gstins/1
  # DELETE /gstins/1.json
  def destroy
    render json: @gstin.destroy, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gstin
      @gstin = Gstin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gstin_params
      params.require(:gstin).permit(:gstin_number, :state_code, :entity_id, :username)
    end

    def common_query
      params[:entity_id].present? ? {entity_id: params[:entity_id]} : {}
    end
end
