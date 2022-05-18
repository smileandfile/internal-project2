class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.text :address
      t.string :location

      t.timestamps
    end
    add_reference :branches, :gstin, index: true
  end
end
