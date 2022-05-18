# == Schema Information
#
# Table name: branches_users
#
#  user_id   :integer          not null
#  branch_id :integer          not null
#

class BranchesUser < ApplicationRecord
  belongs_to :user
  belongs_to :branch
  validates :branch, presence: true, on: :create
  validates :user, presence: true, on: :create
end
