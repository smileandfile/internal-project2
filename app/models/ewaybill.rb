# == Schema Information
#
# Table name: ewaybills
#
#  id                    :integer          not null, primary key
#  party_name            :string
#  mobile_number         :string
#  email                 :string
#  address               :string
#  gstin                 :string
#  client_id             :string
#  client_secret         :string
#  bill_request_count    :integer
#  token_request_count   :integer
#  is_active             :integer
#  auth_token            :string
#  auth_token_expires_at :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  auth_encrypted_sek    :string
#  auth_decrypted_sek    :string
#  app_key               :string(1000000)
#  endpoint_name         :string
#  eway_environment      :integer
#

class Ewaybill < ApplicationRecord

  before_create :create_client_id_secret
  enum is_active: [:no, :yes], _prefix: true

  validates :party_name, presence: true
  validates :client_id, uniqueness: true
  validates :client_secret, uniqueness: true

  has_many :eway_bill_multiple_auths

  enum eway_environment: [:staging, :production]
  after_initialize :set_default_eway_enviorment, if: :new_record?
  validates :endpoint_name, inclusion: { in: Gsp::Eway::Endpoints::EndpointManager::ORDERED_ENDPOINTS.map(&:to_s),
            message: "%{value} is not a valid endpoint",
            allow_nil: true }

  rails_admin do
    create do
      field :party_name
      field :mobile_number
      field :address
      field :email
      field :is_active
      field :eway_environment
      field :endpoint_name
    end
  end 


  def set_default_eway_enviorment
    self.eway_environment ||= :production
  end

  def self.endpoint_names_for_select
    Gsp::Eway::Endpoints::EndpointManager::ORDERED_ENDPOINTS.map { |a| [a.to_s.demodulize.titleize, a.to_s] }
  end

  def endpoint_name_enum
    Ewaybill.endpoint_names_for_select
  end
  

  def create_client_id_secret
    self.client_id = "snf" + SecureRandom.hex(8)
    self.client_secret = "snf" + SecureRandom.hex(8)
  end

  def update_auth_token(eway, response)
    self.auth_token = eway.auth_token
    self.auth_encrypted_sek = eway.encrypted_sek
    self.auth_decrypted_sek = Base64.strict_encode64(eway.decrypted_sek)
    self.app_key = eway.session_random_key
    self.auth_token_expires_at = Time.now + 6.hours - 10.minutes
  end

end
