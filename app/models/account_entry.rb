# == Schema Information
#
# Table name: account_entries
#
#  id              :integer          not null, primary key
#  account_id      :integer
#  description     :string
#  amount_deducted :decimal(20, 10)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class AccountEntry < ApplicationRecord

  belongs_to :account
end
