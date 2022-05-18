class Dashboard::PackagesController < Dashboard::BaseDashboardController
  before_action :set_package, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index]
  load_and_authorize_resource except: [:purchase, :create, :index]

  # GET /packages
  # GET /packages.json
  def index
    special_order = current_user&.get_special_order
    @order = special_order.present? ? special_order : current_user&.get_order
    if special_order.present?
      redirect_to purchase_dashboard_packages_path, notice: "Please provide your company details"
    elsif @order.present? && @order.active?
      redirect_to dashboard_orders_path
    else
      @packages = Package.where.not(package_type: :only_gstr3b) \
                         .where.not(package_type: :composition_dealer) \
                         .where.not(package_type: :special)
      @sub_packages = SubPackage.all
    end
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  # POST /packages.json
  def create
    @package = Package.new(package_params)

    respond_to do |format|
      if @package.save
        format.html { redirect_to dashboard_package_path(@package), notice: 'Package was successfully created.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        format.html { redirect_to dashboard_package_path(@package), notice: 'Package was successfully updated.' }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_packages_path, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase 
    @domain = current_user.domain
    @order = current_user.get_order
    @package_id = params[:order].present? ? params[:order][:package_id] :  @order&.package.id
    @sub_package_id = params[:order].present? ? params[:order][:sub_package_id] : nil
    @duration_column = params[:order].present? ? params[:order][:duration_column] : nil
    if current_user.has_active_package?
      respond_to do |format|
        message = "Package has already been selected. If you have any problems please contact us at <a href='mailto:sales@smileandfile.com'>sales@smileandfile.com</a>"
        format.html { render 'shared/_successfully_created_modal', locals: { type: 'Domain is already activated',
                                                                    message: message}}
      end
    elsif @order.present?
      @order.package_id = @package_id
      @order.sub_package_id = @sub_package_id
      @order.save
      @order
    else
      @order = Order.new
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params.require(:package).permit(:name, :cost, :description ,:package_type, :expiry_duration_months)
    end
end
