class Dashboard::OrdersController < Dashboard::BaseDashboardController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :make_payment, :online_payment_if_gateway_failure]
  load_and_authorize_resource except: [:create, :make_payment, :update, :online_payment_if_gateway_failure]
  skip_before_action :authenticate_user!, only: [:online_payment_if_gateway_failure]

  # GET /orders
  # GET /orders.json
  def index
    @order = Order.accessible_by(current_ability).last
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    noitce = "We have emailed you a soft copy of the Invoice for your " \
             " records and shall courier you the hard copy on your registered address"
    respond_to do |format|
      format.html { render :show, notice: notice}
      format.pdf { render pdf: 'show', layout: 'pdf' }
    end 
  end
                                                    

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(secure_order_params)
    @order.user = current_user
    @order.token = SecureRandom.base64
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @order.save!
          raise 'GSTIN Number or Pan Number required' if secure_order_params[:gstin_number].empty? || secure_order_params[:pan_number].empty?
          format.html { redirect_to dashboard_order_path(@order), notice: "Please check your draft invoice" }
        end
      rescue Exception => e
        Rails.logger.fatal "Error creating new domain+user #{e.to_s}"
        Rails.logger.fatal e.backtrace.join("\n")
        format.html { redirect_to dashboard_packages_path, notice: e.message }
      end
    end
  end

  def update
    @order.duration_months = nil unless secure_order_params[:duration_column].present?
    if @order.update(secure_order_params)
      redirect_to dashboard_order_path(@order), notice: "Please check you draft invoice"
    else  
      redirect_to purchase_dashboard_packages_path, notice: e.message
    end
  end

  def make_payment
    @order.payment_mode_lock = true
    if  params[:order].present? && params[:order][:user_payment_mode] == "online"
      @order.user_payment_mode = :online
      @order.payment_mode_lock = false
    end  
    @order.save
    if @order.user_payment_mode&.to_sym == :online
      redirect_to ccav_request_handler_dashboard_order_transactions_path(@order)
    else
      UserMailer.delay.send_offline_payment_mail(current_user, @order)
      return redirect_to dashboard_orders_path,
                  notice: "Please check your mail for further instructions."
    end
  end

  def online_payment_if_gateway_failure
    token = params[:token]
    if @order.token == token && !@order.user.has_active_package?
      sign_in :user, @order.user
      redirect_to ccav_request_handler_dashboard_order_transactions_path(@order)
    else
      redirect_to dashboard_path, notice: "Not a valid token."
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def secure_order_params
      params.require(:order).permit(:billing_name, :billing_address, 
                                    :billing_zip, :billing_city, 
                                    :billing_state, :billing_country, 
                                    :billing_tel, :billing_email,
                                    :delivery_name, :delivery_address, 
                                    :delivery_city, :delivery_state,
                                    :delivery_country, :delivery_tel, 
                                    :user_payment_mode, :package_id,
                                    :sub_package_id, :duration_column, :payment_mode_lock,
                                    :gstin_number, :pan_number)
    end

    def secure_domain_params
      params.require(:order).require(:domain).permit(:pan_number, 
                                                     :gstin_number, 
                                                     :company_name)
    end

  end
