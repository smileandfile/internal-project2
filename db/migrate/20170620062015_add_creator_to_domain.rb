class AddCreatorToDomain < ActiveRecord::Migration[5.0]
  def change
  	add_reference :domains, :user, index: true
  end
end
