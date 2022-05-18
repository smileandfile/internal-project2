class Api::BranchesController < Api::SubscriptionActiveController
  include Swagger::Blocks
  skip_before_action :authenticate_user!, only: [:create_access_request]
  before_action :set_branch, only: [:show, :update, :destroy]
  load_and_authorize_resource except: [:create, :new]

  swagger_path '/api/branches' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Fetches all Branches'
      key :operationId, 'listBranches'
      key :tags, ['branch']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :Branch
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
      key :description, 'Create Branch'
      key :operationId, 'createBranch'
      key :tags, ['branch']
      parameter do
        key :name, :gstin_id
        key :in, :path
        key :description, 'Gstin id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :branch
        key :in, :body
        key :description, 'Branch Details'
        schema do
          key :'$ref', :Branch
        end
      end
      response 200 do
        schema do
          key :'$ref', :Branch
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end
  # GET /branches
  # GET /branches.json
  def index
    @branches = Branch.where(common_query).accessible_by(current_ability)
    render json: @branches, status: :ok
  end

  # POST /branches
  # POST /branches.json
  def create
    @branch = Branch.new(branch_params)
    @branch.gstin_id = params[:gstin_id]
    if @branch.save
      render json: @branch, status: :ok
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end
  
  swagger_path '/api/branches/{id}' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "Show a Branch Details"
      key :operationId, "showBranch"
      key :tags, ['branch']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Branch id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        schema do
          key :'$ref', :Branch
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
      key :description, 'Delete Branch'
      key :operationId, 'deleteBranch'
      key :tags, ['branch']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Branch id'
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
      end
      key :description, 'Update Branch'
      key :operationId, 'updateBranch'
      key :tags, ['branch']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Branch id'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      parameter do
        key :name, :branch
        key :in, :body
        key :description, 'Branch Detail'
        schema do
          key :'$ref', :Branch
        end
      end
      response 200 do
        schema do
          key :'$ref', :Branch
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
    render json: @branch, status: :ok
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    if @branch.update(branch_params)
      render json: @branch, status: :ok
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_branch
    @branch = Branch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def branch_params
    params.require(:branch).permit(:name, :address, :location)
  end

  def common_query
    params[:branch_id].present? ? {branch_id: params[:branch_id]} : {}
  end

end
