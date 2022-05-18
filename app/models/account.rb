# == Schema Information
#
# Table name: accounts
#
#  id                 :integer          not null, primary key
#  domain_id          :integer
#  description        :string
#  gstin_allowed_left :integer
#  per_gstin_amount   :decimal(20, 10)
#  credits            :decimal(20, 10)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Account < ApplicationRecord

  belongs_to :domain
  has_many :account_entries

  def update_gstins_left_value(gstin)
    entry = AccountEntry.new
    entry.description = "Create GSTIN #{gstin.gstin_number}"
    entry.account = self
    entry.save
    updated_value_of_gstins_left = self.gstin_allowed_left - 1 
    self.update_column(:gstin_allowed_left, updated_value_of_gstins_left)
  end

end
