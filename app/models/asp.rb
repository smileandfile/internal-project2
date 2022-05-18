# == Schema Information
#
# Table name: asps
#
#  id                  :integer          not null, primary key
#  party_name          :string
#  mobile_number       :string
#  email               :string
#  address             :string
#  username            :string
#  secret_password     :string
#  gstin_request_count :integer
#  token_request_count :integer
#  is_active           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Asp < ApplicationRecord

  after_create :create_username_password

  enum is_active: [:no, :yes]

  validates :party_name, presence: true
  validates :mobile_number, presence: true

  rails_admin do
    create do
      field :party_name
      field :mobile_number
      field :address
      field :email
      field :is_active
    end
  end 

  def create_username_password
    self.username = "ASP" + SecureRandom.random_number(9999).to_s + id.to_s
    self.secret_password = Devise.friendly_token.first(8)
    self.save
  end
  
end
