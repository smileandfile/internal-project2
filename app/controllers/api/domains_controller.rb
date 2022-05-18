class Api::DomainsController < Api::ApiController
  include Swagger::Blocks
  before_action :set_domain, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:create_access_request_admin, :index]


  respond_to :json


  swagger_path '/api/domains' do
    operation :get do
      key :description, 'Fetches all Domains'
      key :operationId, 'listDomains'
      key :tags, ['domain']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Domain
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
      end
      key :description, 'Create Domain'
      key :operationId, 'addDomain'
      key :tags, ['domain']
      parameter do
        key :name, :domain
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :Domain
        end
      end
      response 200 do
        schema do
          key :'$ref', :Domain
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /domains
  # GET /domains.json
  def index 
    @domains = Domain.all.includes(:users, :gstins, :entities, :user)
    render json: @domains.map { |d| d.to_builder.attributes! }, status: :ok
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    render json: @domain.to_builder.attributes!, status: :ok
  end

  # POST /domains
  # POST /domains.json
  def create
    @domain = Domain.new(domain_params)
    if @domain.save
      render json: @domain.to_builder.attributes!, status: :ok
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  swagger_path '/api/domains/{id}' do
    parameter do
      key :name, :id
      key :in, :path
      key :description, 'Domain id'
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "Show Domain"
      key :operstionId, "showDomain"
      key :tags, ['domain']
      response 200 do
        schema do
          key :'$ref', :Domain
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
      end
      key :description, "Update domain"
      key :operationId, 'updateDomain'
      key :tags, ['domain']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Domain id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :domain
        key :in, :body
        key :description, 'Domain to update'
        key :required, true
        schema do
          key :'$ref', :Domain
        end
      end
      response 200 do
        schema do
          key :'$ref', :Domain
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
      end
      key :description, 'Delete Domain'
      key :operationId, 'deleteDomain'
      key :tags, ['domain']
      response 200
      response :unauthorized
      response :not_acceptable
    end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    if @domain.update(domain_params)
      render json: @domain.to_builder.attributes!, status: :ok
    else
      render json: @domain.errors, status: :unprocessable_entity
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    render json: @domain.destroy, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    @domain = Domain.find(params[:id])
  end

  def secure_user_params
    params.require(:user).permit(:name, :email, :password)
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def domain_params
    params.require(:domain).permit(:name, :pan_number, :gstin, :address,
                                    :firm_name, :firm_turnover, :user_id)
  end
end
