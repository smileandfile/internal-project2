# == Schema Information
#
# Table name: roles
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#  parent_id       :integer
#  allowed_actions :string           default([]), is an Array
#

class Role < ApplicationRecord
  include Swagger::Blocks

  before_save :remove_blank_allowed_actions 

  swagger_schema :Role do
    property :name do
      key :type, :string
    end
    property :allowed_actions do
      key :type, :array
    end
    property :parent_id do
      key :type, :integer
    end
  end

  def parent_name
    if parent_id.present?
      Role.find(parent_id)&.name
    end
  end


  def to_builder
    Jbuilder.new do |json|
      json.(self, :name, :allowed_actions)
    end
  end


  def remove_blank_allowed_actions
    allowed_actions.reject!(&:blank?)
  end

end
