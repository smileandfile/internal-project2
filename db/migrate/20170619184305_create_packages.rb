class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :package_type
      t.string :cost
      t.text :description
      

      t.timestamps
    end
  end
end
