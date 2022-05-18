# == Schema Information
#
# Table name: gstins_users
#
#  user_id  :integer          not null
#  gstin_id :integer          not null
#

class GstinsUser < ApplicationRecord

  belongs_to :user
  belongs_to :gstin
  validates :user, presence: true, on: :create
  validates :gstin, presence: true, on: :create

end
