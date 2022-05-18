# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  amount                 :decimal(, )      not null
#  currency               :string           not null
#  tracking_id            :string
#  billing_name           :string
#  billing_address        :text
#  billing_zip            :string
#  billing_city           :string
#  billing_state          :string
#  billing_country        :string
#  billing_tel            :string
#  billing_email          :string
#  delivery_name          :string
#  delivery_address       :string
#  delivery_city          :string
#  delivery_state         :string
#  delivery_country       :string
#  delivery_tel           :string
#  promo_code             :string
#  discounted_amount      :string
#  status                 :integer
#  cc_avenue_order_status :string
#  bank_ref_no            :string
#  failure_message        :string
#  payment_mode           :string
#  card_name              :string
#  status_code            :string
#  status_message         :string
#  merchant_param1        :string
#  merchant_param2        :string
#  merchant_param3        :string
#  merchant_param4        :string
#  merchant_param5        :string
#  vault                  :string
#  offer_type             :string
#  offer_code             :string
#  discount_value         :string
#  mer_amount             :string
#  eci_value              :string
#  retry                  :string
#  response_code          :string
#  billing_notes          :string
#  trans_date             :string
#  bin_country            :string
#  package_id             :integer
#  user_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_payment_mode      :integer
#  subscription           :integer
#  sgst                   :decimal(8, 2)
#  cgst                   :decimal(8, 2)
#  igst                   :decimal(8, 2)
#  without_tax_amount     :decimal(8, 2)
#  sub_package_id         :integer
#  duration_months        :integer
#  offline_payment_date   :datetime
#  payment_mode_lock      :boolean          default(FALSE)
#  invoice_number         :string
#  token                  :string
#  is_payment_url_sent    :boolean          default(FALSE)
#  utr_number             :string
#  bank_name              :string
#  date_remittance        :datetime
#  cheque_number          :string
#  special_type           :boolean          default(FALSE)
#  gstin_number           :string
#  pan_number             :string
#

# payment_mode  = {
#   0 => "Online payment",
#   1 => "Payment by Cheque",
#   2 => "Draft",
#   3 => "Neft or RTGS"
# }

STATES_ARRAY = [
  ['Andaman and Nicobar Islands', '35', 'AN'],
  ['Andhra Pradesh', '28', 'AP'],
  ['Andhra Pradesh (New)', '37', 'AD'],
  ['Arunachal Pradesh', '12', 'AR'],
  ['Assam', '18', 'AS'],
  ['Bihar', '10', 'BH'],
  ['Chandigarh', '04', 'CH'],
  ['Chattisgarh', '22', 'CT'],
  ['Dadra and Nagar Haveli', '26', 'DN'],
  ['Daman and Diu', '25', 'DD'],
  ['Delhi', '07', 'DL'],
  ['Goa', '30', 'GA'],
  ['Gujarat', '24', 'GJ'],
  ['Haryana', '06', 'HR'],
  ['Himachal Pradesh', '02', 'HP'],
  ['Jammu and Kashmir', '01', 'JK'],
  ['Jharkhand', '20', 'JH'],
  ['Karnataka', '29', 'KA'],
  ['Kerala', '32', 'KL'],
  ['Lakshadweep Islands', '31', 'LD'],
  ['Madhya Pradesh', '23', 'MP'],
  ['Maharashtra', '27', 'MH'],
  ['Manipur', '14', 'MN'],
  ['Meghalaya', '17', 'ME'],
  ['Mizoram', '15', 'MI'],
  ['Nagaland', '13', 'NL'],
  ['Odisha', '21', 'OR'],
  ['Pondicherry', '34', 'PY'],
  ['Punjab', '03', 'PB'],
  ['Rajasthan', '08', 'RJ'],
  ['Sikkim', '11', 'SK'],
  ['Tamil Nadu', '33', 'TN'],
  ['Telangana', '36', 'TS'],
  ['Tripura', '16', 'TR'],
  ['Uttar Pradesh', '09', 'UP'],
  ['Uttarakhand', '05', 'UT'],
  ['West Bengal', '19', 'WB']
]

STATE_CODES = STATES_ARRAY.map do |name, code, short|
  { full_name: name, code: code, short_name: short }.with_indifferent_access
end

PAYMENT_TYPES = { online: 'Online Payment', cheque_draft: 'Cheque/Draft', neft_rtgs: 'NEFT/RTGS'}

class Order < ApplicationRecord

  enum status: [:pending, :success, :failed]
  enum user_payment_mode: [:online, :cheque_draft, :neft_rtgs]
  enum subscription: [:active, :deactive]
  belongs_to :package
  belongs_to :user
  belongs_to :sub_package
  after_update :make_domain_active
  before_validation :set_params_after_create, :set_without_tax_amount, 
                    :update_tax, if: :new_record?
  before_update :update_tax
  validates :package, presence: true, on: :create
  validates :amount, presence: true, on: :create
  validates :billing_state, presence: true, on: :create
  validates :billing_name, presence: true

  after_update :send_payment_url_mail

  scope :online_failed_orders, -> { where("cc_avenue_order_status != ? ", 'Success') }
  scope :neft_orders, -> { where(user_payment_mode: :neft_rtgs) }
  scope :cheque_orders, -> { where(user_payment_mode: :cheque_draft) }
  scope :online_orders, -> { where(user_payment_mode: :online) }
  scope :pending_cheque_orders, -> { deactive.where(user_payment_mode: :cheque_draft) }
  scope :pending_neft_orders, -> { deactive.where(user_payment_mode: :neft_rtgs) }
  scope :pending_online_orders, -> { deactive.where(user_payment_mode: :online) }

  def send_payment_url_mail
    if user_payment_mode&.to_sym == :online && ( cc_avenue_order_status == "Failure" || cc_avenue_order_status == "Aborted" ) && !is_payment_url_sent
      UserMailer.delay.payment_url_mail(self)
      self.is_payment_url_sent = true
      self.save
    end
  end
  
  def update_tax
    tax_percentage = 0.09
    tax_value = tax_percentage * without_tax_amount.to_f
    igst = cgst = sgst = 0.00
    tax_value = tax_value
    if is_intra_state_order
      sgst = cgst = tax_value
    else
      igst = 2 * tax_value
    end
    self.amount = (without_tax_amount.to_f + igst + cgst + sgst).round(2)
    self.igst = igst
    self.sgst = sgst
    self.cgst = cgst
  end

  def is_intra_state_order
    billing_state == '27'
  end


  def is_payment_mode_locked
    payment_mode_lock && active?
  end

  def make_domain_active
    if !user.has_active_package? && subscription.to_sym == :active
      UserMailer.delay.send_invoice(self)
      @domain = user.domain
      @domain.make_domain_active(package, self)
      @domain.save
    end
  end

  def generate_invoice_number
    last_active_order = Order.where.not(invoice_number: nil) \
                             .where.not(invoice_number: '') \
                             .order(invoice_number: :desc).first
    invoice_id = if last_active_order.nil?
                   1
                 else
                   last_active_order.invoice_number.split('/')[-1].to_i + 1
                 end
    self.invoice_number = "MH/#{Time.new.year.to_s.last(2)}/SB/#{invoice_id}"
    self
  end

  def billing_state_full_name_with_code
    selected_state = STATE_CODES.select { |e| e['code'] == billing_state }[0]
    "#{selected_state['full_name']} (#{selected_state['code']})"
  end

  def billing_state_full_name
    STATE_CODES.select { |e| e['code'] == billing_state }[0]['full_name']
  end

  def duration_column=(duration_column)
    @duration_column = duration_column
    # now for we added +3 month
    self.duration_months = case duration_column
                           when 'annual'
                             12 + 3
                           when 'half_yearly'
                             6 + 3
                           when 'quarterly'
                             3
                           end
    set_without_tax_amount
  end

  def duration_column
    @duration_column
  end

  private

  def set_params_after_create
    self.currency ||= 'INR'
    self.subscription ||= :deactive
    self.status ||= :pending
  end

  def set_without_tax_amount
    if duration_column.nil? || sub_package.nil?
      self.without_tax_amount = package.cost
      return
    end
    raise(ArgumentError, "Unknown duration column #{duration}") unless \
         %w[annual half_yearly quarterly].include? duration_column
    self.without_tax_amount = sub_package.send(duration_column)
  end

  def update_tax
    tax_percentage = 0.09
    tax_value = tax_percentage * without_tax_amount.to_f
    igst = cgst = sgst = 0.00
    tax_value = tax_value
    if is_intra_state_order
      sgst = cgst = tax_value
    else
      igst = 2 * tax_value
    end
    # take_deposit (initial deposit amount for gsp suvidha provider package type)
    self.amount = (without_tax_amount.to_f + igst + cgst + sgst).round(2) + self.package.take_deposit
    self.igst = igst
    self.sgst = sgst
    self.cgst = cgst
  end

  def domain_name
    user&.domain&.name
  end

  rails_admin do
    list do
      scopes [nil, :online_failed_orders, :cheque_orders, :neft_orders, :online_orders, :pending_cheque_orders, :pending_neft_orders, :pending_online_orders]
      field :id
      field :domain_name
      field :user
      field :amount
      field :billing_name
      field :billing_address
      field :subscription
      field :status
    end
  end

end
