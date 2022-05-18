class Dashboard::GstinsController < Dashboard::DashboardController
  before_action :set_gstin, only: [:show, :update, :edit, :destroy]
  load_and_authorize_resource except: [:create, :new]

  before_action :check_package_type, only: [:create, :new]

  # GET /gstins
  # GET /gstins.json
  def index
    @gstins = Gstin.accessible_by(current_ability)
  end

  # GET /gstins/1
  # GET /gstins/1.json
  def show
  end

  def new
    @gstin = Gstin.new
    @entities = Entity.accessible_by(current_ability)
  end

  # POST /gstins
  # POST /gstins.json
  def create
    @gstin = Gstin.new(gstin_params)
    @gstin.user = current_user
    @gstin.domain = current_user.domain
    @gstin.state_code = @gstin.gstin_number.first(2)
    respond_to do |format|
      if @gstin.save
        if @gstin.domain&.package&.is_package_credit_type
          @account = @gstin.domain.account_details
          @account.update_gstins_left_value(@gstin)
        end
        format.html { redirect_to dashboard_gstin_path(@gstin), notice: 'Gstin was successfully created.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'GSTIN CREATED', message: ''} }
        format.json { render :show, status: :created, location: @gstin }
      else
        format.html { render :new }
        @model = @gstin
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end


  # PATCH/PUT /gstins/1
  # PATCH/PUT /gstins/1.json
  def update
    respond_to do |format|
      if @gstin.update(gstin_params)
        format.html { redirect_to dashboard_gstin_path(@gstin), notice: 'Gstin was successfully updated.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'GSTIN Updated', message: ''} }
        format.json { render :show, status: :created, location: @gstin }
      else
        format.html { render :new }
        @model = @gstin
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end

  def destroy
    gstin_number = @gstin.gstin_number
    @gstin.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_gstins_path, notice: "Successfully deleted the gstin #{gstin_number}" }
    end
  end

  def check_package_type
    domain = current_user.domain
    @package = domain.package
    if @package.is_package_credit_type
      @account = domain.account_details
      if @account.gstin_allowed_left >= 1
        return true
      else
        redirect_to dashboard_account_details_path, notice: "Please first topup some credits"
      end 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gstin
      @gstin = Gstin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gstin_params
      params.require(:gstin).permit(:gstin_number, :state_code, :entity_id, 
                                    :username, :gsp_environment, 
                                    :registration_date, :dealer_type, 
                                    :turnover_last_year, :turnover_current,
                                    :endpoint_name)
    end
end
