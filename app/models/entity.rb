# == Schema Information
#
# Table name: entities
#
#  id           :integer          not null, primary key
#  company_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  domain_id    :integer
#  address      :text
#  pan_number   :string
#

class Entity < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :Entity do
    key :required, [:domain_id]
    property :id do
      key :type, :integer
    end
    property :company_name do
      key :type, :string
    end
    property :address do
      key :type, :string
    end
    property :pan_number do
      key :type, :string
    end
    property :domain_id do
      key :type, :integer
    end
  end

  has_many :gstins, dependent: :destroy
  has_many :branches, dependent: :destroy
  belongs_to :domain, touch: true
  validates :domain, presence: true, on: :create

  validates :address, presence: true, on: :create
  validates :company_name, presence: true, on: :create

  validates :pan_number, presence: true, pan_number: true, on: :create

  def to_builder
    Jbuilder.new do |json|
      json.(self, :id, :company_name , :address, :pan_number, :domain_id)
    end
  end

end
