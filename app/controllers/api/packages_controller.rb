class Api::PackagesController < Api::ApiController

  before_action :set_package, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  respond_to :json


  def index
    @packages = Package.all
    render json: @packages, status: :ok
  end


  def show
    render json: @entity, status: :ok
  end

  # GET /packages/1/edit
  def edit
  end


  def create
    @package = Package.new(package_params)
    if @package.save
      render json: @package, status: :created
    else
      render json: @package.errors, status: :unprocessable_entity
    end
  end


  def update
    if @package.update(package_params)
      render json: @package.errors, status: :unprocessable_entity
    else
      render json: @package.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @package.destroy
    render json: {msg: "Package was successfully destroyed."}
  end

  def purchase
    @package = Package.find(params[:id])
    @order = Order.new
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.require(:package).permit(:name, :cost, :package_type, :description, :expiry_duration_months)
    end
end
