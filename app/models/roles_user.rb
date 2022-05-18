# == Schema Information
#
# Table name: roles_users
#
#  user_id :integer          not null
#  role_id :integer          not null
#

class RolesUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
  validates :role, presence: true, on: :create
  validates :user, presence: true, on: :create
end
