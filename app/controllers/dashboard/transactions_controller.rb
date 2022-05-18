class Dashboard::TransactionsController < Dashboard::BaseDashboardController
  skip_before_action :verify_authenticity_token, only: [:ccav_request_handler,
                                                        :ccav_response_handler,
                                                        :cancel_url, :topup_ccav_request_handler,
                                                        :topup_ccav_response_handler,
                                                        :topup_cancel_url]
  before_action :ccav_crypto

  def ccav_crypto
    @@ccav_crypto ||= CcavCrypto.new
  end

  def ccav_request_handler
    order = Order.find(params[:order_id])
    merchant_id = '137357'
    data = order.as_json
    # TODO for testing amount is rs 1
    data['amount']  = 1 if ENV['SNF_ALWAYS_CHARGE_ONE_RUPEE'].nil?
    data['billing_state'] = order.billing_state_full_name
    data['redirect_url'] = ccav_response_handler_dashboard_order_transactions_url(order)
    data['cancel_url'] = cancel_url_dashboard_order_transactions_url(order)
    data['language'] = 'EN'
    data['order_id'] = order.id
    data['merchant_id'] = merchant_id
    @encrypted_data = make_encrypted_data(data)
    @access_code = ENV['CC_AVENUE_ACCESS_CODE'] || 'AVYZ71EF60CE33ZYEC'
    render :ccav_request_handler
  end

  # success response
  # {"order_id"=>["4"], "tracking_id"=>["106262742317"], "bank_ref_no"=>["1267376648"], "order_status"=>["Success"],
  #  "failure_message"=>[""], "payment_mode"=>["Net Banking"], "card_name"=>["ICICI Bank"], "status_code"=>["null"],
  #  "status_message"=>["SUCCESS"], "currency"=>["INR"], "amount"=>["1.18"], "billing_name"=>["Ankit"], 
  #  "billing_address"=>["Noida"], "billing_city"=>["Abdul"], "billing_state"=>["MH"], "billing_zip"=>["230212"],
  #  "billing_country"=>["India"], "billing_tel"=>["918860019688"], "billing_email"=>["ankitkhadria1@gmail.com"], 
  #  "delivery_name"=>["Ankit"], "delivery_address"=>["Noida"], "delivery_city"=>["Abdul"], "delivery_state"=>["MH"], 
  # "delivery_zip"=>["230212"], "delivery_country"=>["India"], "delivery_tel"=>["918860019688"], "merchant_param1"=>[""],
  #  "merchant_param2"=>[""], "merchant_param3"=>[""], "merchant_param4"=>[""], "merchant_param5"=>[""], "vault"=>["N"], 
  # "offer_type"=>["null"], "offer_code"=>["null"], "discount_value"=>["0.0"], "mer_amount"=>["1.18"], "eci_value"=>["null"], 
  # "retry"=>["N"], "response_code"=>["0"], "billing_notes"=>[""], "trans_date"=>["06/08/2017 23:13:22"], "bin_country"=>[""]}
  def ccav_response_handler
    @order = save_details_after_transaction(decrypted_data)
    package = @order.package
    respond_to do |format|
      if @order.cc_avenue_order_status == 'SUCCESS'
        @order.status = :success
        @order.subscription = :active
        format.html {redirect_to dashboard_orders_path, notice: 'Domain activated successfully.'}
      else
        @order.payment_mode_lock = false
        format.html {redirect_to dashboard_order_path(@order), notice: "Payment status #{@order.cc_avenue_order_status} "}
      end
      @order.save
    end
  end

  def cancel_url
    @order = save_details_after_transaction(decrypted_data)
    @order.status = :failed
    @order.payment_mode_lock = false
    @order.save
    respond_to do |format|
      format.html {redirect_to dashboard_order_path(@order), notice: @order.failure_message}
    end
  end

  def topup_ccav_request_handler
    @account = current_user.domain.account_details
    amount = params[:amount]
    data = {}
    data['amount']  = amount
    data['redirect_url'] = topup_ccav_response_handler_dashboard_transactions_url
    data['billing_name'] = current_user.name
    data['billing_email'] = current_user.email
    data['cancel_url'] = topup_cancel_url_dashboard_transactions_url
    data['language'] = 'EN'
    data['order_id'] = @account.id
    data['currency'] = "INR"
    data['merchant_id'] = ENV['CC_AVENUE_MERCHANT_ID']
    @encrypted_data = make_encrypted_data(data)
    @access_code = ENV['CC_AVENUE_ACCESS_CODE'] || 'AVYZ71EF60CE33ZYEC'
    render :ccav_request_handler
  end

  def topup_ccav_response_handler
    @account = current_user.domain.account_details
    response_data = decrypted_data
    amount = response_data['amount'][0]
    respond_to do |format|
      if response_data['status_message'][0] == 'SUCCESS'
        @account.credits = @account.credits + amount.to_f
        entry = AccountEntry.new
        entry.description = "Top up of #{amount} added to credits"
        entry.amount_deducted = 0
        entry.account = @account
        entry.save!
        @account.save!
        format.html {redirect_to dashboard_account_details_path, notice: 'Successfully added.'}
      else
        format.html {redirect_to dashboard_account_details_path, notice: "Payment status #{response_data['order_status'][0]}"}
      end
    end
  end

  def topup_cancel_url
    @account = current_user.domain.account_details
    response_data = decrypted_data
    respond_to do |format|
      format.html {redirect_to dashboard_account_details_path, notice: response_data['order_status'][0]}
    end
  end


  private

  def make_encrypted_data(data)
    merchantData=""
    working_key = ENV['CC_AVENUE_WORKING_KEY'] || '0CDACBCDB4D3CEDE69EE7849EE56B213'
    data.each do |key, value|
        merchantData += key+"="+value.to_s+"&"
    end
    encrypted_data = @@ccav_crypto.encrypt(merchantData,working_key)
  end

  def save_details_after_transaction(response_data)
    order_id = response_data['order_id']
    @order = Order.find(order_id).first
    @order.tracking_id = response_data['tracking_id'][0]
    @order.bank_ref_no = response_data['bank_ref_no'][0]
    @order.cc_avenue_order_status = response_data['order_status'][0]
    @order.failure_message = response_data['failure_message'][0]
    @order.payment_mode = response_data['payment_mode'][0]
    @order.card_name = response_data['card_name'][0]
    @order.status_code = response_data['status_code'][0]
    @order.status_message = response_data['status_message'][0]
    @order.merchant_param1 = response_data['merchant_param1'][0]
    @order.merchant_param2 = response_data['merchant_param2'][0]
    @order.merchant_param3 = response_data['merchant_param3'][0]
    @order.merchant_param4 = response_data['merchant_param4'][0]
    @order.merchant_param5 = response_data['merchant_param5'][0]
    @order.vault = response_data['vault'][0]
    @order.offer_type = response_data['offer_type'][0]
    @order.offer_code = response_data['offer_code'][0]
    @order.discount_value = response_data['discount_value'][0]
    @order.mer_amount = response_data['mer_amount'][0]
    @order.eci_value = response_data['eci_value'][0]
    @order.retry = response_data['retry'][0]
    @order.response_code = response_data['response_code'][0]
    @order.billing_notes = response_data['billing_notes'][0]
    @order.trans_date = response_data['trans_date'][0]
    @order.bin_country = response_data['bin_country'][0]
    @order.save
    @order
  end

  def decrypted_data
    merchantData=params[:encResp]
    working_key = ENV['CC_AVENUE_WORKING_KEY'] || '0CDACBCDB4D3CEDE69EE7849EE56B213'
    response_data = @@ccav_crypto.decrypt(merchantData ,working_key)
    response_data = CGI.parse(response_data)
  end

  def set_package
    @package = Package.find(params[:id])
  end
  
end
