# == Schema Information
#
# Table name: eway_bill_multiple_auths
#
#  id                    :integer          not null, primary key
#  ewaybill_id           :integer
#  gstin                 :string
#  auth_token            :string
#  auth_token_expires_at :datetime
#  auth_encrypted_sek    :string
#  auth_decrypted_sek    :string
#  app_key               :string(1000000)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  token_created_at      :datetime
#

class EwayBillMultipleAuth < ApplicationRecord

  belongs_to :ewaybill

  def update_auth_token(eway, response)
    self.auth_token = eway.auth_token
    self.auth_encrypted_sek = eway.encrypted_sek
    self.auth_decrypted_sek = Base64.strict_encode64(eway.decrypted_sek)
    self.app_key = eway.session_random_key
    self.auth_token_expires_at = Time.now + 6.hours - 10.minutes
    self.token_created_at = Time.now
  end

  def unset_auth_token
    self.auth_token = nil
    self.auth_encrypted_sek = nil
    self.auth_decrypted_sek = nil
    self.auth_token_expires_at = nil
  end

end
