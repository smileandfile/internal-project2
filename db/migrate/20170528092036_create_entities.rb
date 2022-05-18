class CreateEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :entities do |t|
      t.string :company_name

      t.timestamps
    end
    add_reference :entities, :domain, index: true
  end
end
