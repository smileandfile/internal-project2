# == Schema Information
#
# Table name: file_download_gstins
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
#  branch_id                    :integer
#

class FileDownloadGstin < ApplicationRecord

  enum dealer_type: [:regular, :composition]
  enum gsp_environment: [:staging, :preprod, :production]
  after_initialize :set_default_gsp_enviorment, if: :new_record?

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
