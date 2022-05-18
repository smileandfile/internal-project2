# == Schema Information
#
# Table name: branches
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :text
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  gstin_id   :integer
#  entity_id  :integer
#

class Branch < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :Branch do
    key :required, [:name, :gstin_id]
    property :id do
      key :type, :integer
    end
    property :name do
      key :type, :string
    end
    property :location do
      key :type, :string
    end
    property :address do
      key :type, :string
    end
    property :gstin_id do
      key :type, :integer
    end
  end

  belongs_to :gstin
  belongs_to :entity
  validates :gstin, presence: true, on: :create
  validates :entity, presence: true, on: :create

end
