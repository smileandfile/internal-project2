# == Schema Information
#
# Table name: gstins
#
#  id                           :integer          not null, primary key
#  gstin_number                 :string
#  state_code                   :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  auth_token                   :string
#  auth_encrypted_sek           :string
#  auth_decrypted_sek           :string
#  username                     :string
#  user_id                      :integer
#  entity_id                    :integer
#  gsp_environment              :integer
#  registration_date            :datetime
#  dealer_type                  :integer
#  turnover_last_year           :integer
#  turnover_current             :integer
#  domain_id                    :integer
#  endpoint_name                :string
#  auth_expires_at              :datetime
#  app_key                      :string(1000000)
#  auth_token_expires_at        :datetime
#  server_time                  :datetime
#  actual_time_of_token_expires :integer
#

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

class Gstin < ApplicationRecord
  include Swagger::Blocks

  rails_admin do
    list do
      field :id
      field :gstin_number
      field :username
      field :entity
    end
  end 

  swagger_schema :Gstin do
    property :id do
      key :type, :integer
    end
    property :gstin_number do
      key :type, :string
      key :format, /\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$/
    end
    property :state_code do
      key :type, :integer
      key :format, /^[0-9]{2}$/
    end
    property :registration_date do
      key :type, :string
    end
    property :dealer_type do
      key :type, :string
    end
    property :turnover_last_year do
      key :type, :integer
    end
    property :turnover_current do
      key :type, :integer
    end
    property :username do
      key :type, :string
    end
    property :auth_expires_at do
      key :type, :string
      key :format, :"date-time"
    end
    property :auth_token_expires_at do
      key :type, :string
      key :format, :"date-time"
    end
  end

  enum dealer_type: [:regular, :composition]
  enum gsp_environment: [:staging, :preprod, :production]
  after_initialize :set_default_gsp_enviorment, if: :new_record?

  has_many :branches, dependent: :destroy
  belongs_to :user
  belongs_to :entity
  has_many :file_downloads
  belongs_to :domain, touch: true
  before_validation :make_endpoint_name_nil_if_blank
  validates :endpoint_name, inclusion: { in: Gsp::Endpoints::EndpointManager::ORDERED_ENDPOINTS.map(&:to_s),
                                         message: "%{value} is not a valid endpoint",
                                         allow_nil: true }
  # validates :gstin_number, presence: true, length: { is: 15 }, on: :create
  validates :gstin_number, presence: true, gstin_number: true, on: :create
  validates :state_code, length: { is: 2 },
                         format: {
                           with: /^[0-9]{2}$/,
                           message: 'is not in correct formats Ex. 27',
                           multiline: true
                         }, on: :create

  validates :turnover_last_year, presence: true
  validates :turnover_current, presence: true
  validates :entity_id, presence: true
  validates :username, presence: true
  validates :dealer_type, presence: true
  validates :registration_date, presence: true

  # POST user/current_gstin
  def current_gstin(params)
    # do auth and existence check (cancancan needs to be used)
  end

  def set_default_gsp_enviorment
    self.gsp_environment ||= :production
  end

  def self.states_for_select
    STATE_CODES.map { |a| ["#{a['full_name']} (#{a['code']})", a['code']] }
  end

  def self.endpoint_names_for_select
    Gsp::Endpoints::EndpointManager::ORDERED_ENDPOINTS.map { |a| [a.to_s.demodulize.titleize, a.to_s] }
  end

  def endpoint_name_enum
    Gstin.endpoint_names_for_select
  end

  def refresh_auth_token(user_ip, current_user)
    @@gsp_api ||= Gsp::AuthenticatedApi.new()
    @@gsp_api.prepare_for_gstin(self, user_ip, current_user)
    gst_response = @@gsp_api.extend_auth_token(self, auth_token, username)
    begin
      if gst_response[:body]['status_cd'] == "1"
        user_ip = current_user.current_sign_in_ip
        self.delay(run_at: (6.hours - 20.minutes).from_now(Time.now)).refresh_auth_token(user_ip, current_user)
        # self.delay(run_at: 1.hours.from_now(Time.now)).refresh_auth_token(user_ip, current_user)
      end
    rescue Exception => e
      return true
    end
  end


  def load_auth_attributes_from(api, update_expires_at =  false)
    self.auth_token = api.auth_token
    self.app_key = Base64.strict_encode64(self.app_key)
    self.auth_expires_at = api.expires_at if update_expires_at
    self.auth_encrypted_sek = api.encrypted_sek
    self.auth_decrypted_sek = api.session_encryption_key
    self.auth_token_expires_at = api.token_expires_at
    self.server_time = Time.now
    self.actual_time_of_token_expires = auth_expires_at - server_time
  end

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :gstin_number , :state_code, 
            :registration_date, :dealer_type, 
            :turnover_last_year, :turnover_current,
            :username, :auth_expires_at, :auth_token_expires_at,
            :server_time, :actual_time_of_token_expires, :auth_token)
    end
  end

  #minimum purchasing amount 2000
  def purchase_gstin
   account = Plutus::Asset.find_by_name(self.domain.name)
   if account.gstin_left > 0
    
   end
  end

  private

  def make_endpoint_name_nil_if_blank
    self.endpoint_name = nil if endpoint_name.blank?
  end
end
