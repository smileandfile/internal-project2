class AddCreatorToGstin < ActiveRecord::Migration[5.0]
  def change
  	add_reference :gstins, :user, foreign_key: true, index: true
  end
end
