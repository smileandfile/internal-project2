class CreateGstins < ActiveRecord::Migration[5.0]
  def change
    create_table :gstins do |t|
    	t.integer :gstin_number, limit: 8
      t.integer :state_code

      t.timestamps
    end
    add_reference :gstins, :entity, index: true
  end
end
