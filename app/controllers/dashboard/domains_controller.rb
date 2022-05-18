class Dashboard::DomainsController < Dashboard::DashboardController
  before_action :set_domain, only: [:show, :update, :destroy, :edit,
                                    :create_access_request_new_user, :domain_users]
  skip_before_action :authenticate_user!,
                     :check_subcription_active,
                     :check_email_verified,
                     :check_phone_verified,
                     only: %i[index create_access_request_new create_access_request_admin]

  load_and_authorize_resource except: [:create, :create_access_request_new,
                                       :create_access_request_admin,
                                       :account_details, :purchase_gstins]

  # GET /domains
  # GET /domains.json
  def index
    @domain = current_user.domain
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    entities = @domain.entities
  end

  def new
    @domain = Domain.new
  end

  # GET /domains/1/edit
  def edit
  end

  # POST /domains
  # POST /domains.json
  def create
    @domain = Domain.new(domain_params)
    respond_to do |format|
      if @domain.save
        format.html { redirect_to dashboard_domain_path(@domain), notice: 'Domain was successfully created.' }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    respond_to do |format|
      if @domain.update_attributes(domain_params.reject { |k| k.to_sym == :name })
        format.html { redirect_to dashboard_domain_path(@domain), notice: 'Domain was successfully updated.' }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    @domain.destroy
  end

  def create_access_request_new
    if current_user&.domain.present?
      if current_user.domain.is_active
        return redirect_to dashboard_path, notice: 'Please log out to create a new Domain.'
      else
        @domain = current_user.domain
        return
      end
    end

    @domain = Domain.new
    @domain.build_user
  end

  def create_access_request_admin
    secure_domain_hash = domain_params.to_h
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @domain = Domain.new(secure_domain_hash)
          @user = @domain.user
          @user.role = :admin
          @domain.save!
          @user.domain = @domain
          # @user.skip_confirmation!
          # @user.delay.send_confirmation_instructions # manually send instructions
          @user.save!
          sign_in :user, @user
          format.html { redirect_to otp_authenticate_path }
          format.js { render :create_access_request_admin }
        end
      rescue Exception => e
        Rails.logger.fatal "Error creating new domain+user #{e.to_s}"
        Rails.logger.fatal e.backtrace.join("\n")
        format.html { render :create_access_request_new }
        @model = @domain
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render :create_access_request_admin }
      end
    end
  end


  def special_domain_creation
    return root_path if current_user&.admin?
    @domain = Domain.new
    @domain.build_user
    @domain.build_package
  end

  def special_domain
    return root_path if current_user&.admin?
    secure_domain_hash = special_domain_params.to_h
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @domain = Domain.new(secure_domain_hash)
          @user = @domain.user
          @user.role = :admin
          @domain.save!
          @user.domain = @domain
          @user.save!
          @order = Order.new
          @order.user = @user
          @order.package = @domain.package
          @order.special_type = true
          @order.billing_state =  "01"
          @order.billing_name = "ABC Pvt. Ltd."
          @order.save!
          format.html { redirect_to root_path, notice: "Successfully created domain #{@domain.name}" }
        end
      rescue Exception => e
        Rails.logger.fatal "Error creating new domain+user #{e.to_s}"
        Rails.logger.fatal e.backtrace.join("\n")
        format.html { render :special_domain_creation }
      end
    end
  end

  def account_details
    @account = current_user.domain.account_details
    @entries = @account&.account_entries
  end

  def purchase_gstins
    @account = current_user.domain.account_details
    number_of_gstins = params[:number_of_gstins].to_i
    without_tax_amount = number_of_gstins * @account.per_gstin_amount
    after_tax_amount = without_tax_amount * 0.18 + without_tax_amount
    if @account.credits > after_tax_amount
      @account.credits = @account.credits - after_tax_amount
      @account.gstin_allowed_left = @account.gstin_allowed_left + number_of_gstins
      @account.save! 
      entry = AccountEntry.new
      entry.description = "#{number_of_gstins} more limits added to GSTINS"
      entry.amount_deducted = after_tax_amount
      entry.account = @account
      entry.save!
      redirect_to dashboard_account_details_path, notice: "Successfully increased limit to create more GSTINS"
    else    
      redirect_to dashboard_account_details_path, notice: "You don't have enough credit please topup first."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_domain
      @domain = Domain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      params.require(:domain).permit(:name, :address, :pan_number, :firm_turnover,
                                     :gstin_number, :company_name,
                                     user_attributes: [:name, :email, :password, :phone_number])
    end

    def special_domain_params
      params.require(:domain).permit(:name, :address, :pan_number, :firm_turnover,
                                     :gstin_number, :company_name,
                                     user_attributes: [:name, :email, :password, :phone_number],
                                     package_attributes: [:package_type, :description, :turnover_from, :turnover_to, :cost, :name, :expiry_duration_months])
    end

    def secure_user_params
      params.require(:user).permit(:name, :password, :email, :phone_number)
    end

end
