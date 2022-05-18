# == Schema Information
#
# Table name: entities_users
#
#  user_id   :integer          not null
#  entity_id :integer          not null
#

class EntitiesUser < ApplicationRecord

  belongs_to :user
  belongs_to :entity
  validates :entity, presence: true, on: :create
  validates :user, presence: true, on: :create
  
end
