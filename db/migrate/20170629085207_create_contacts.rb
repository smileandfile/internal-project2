class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email, null: false
      t.string :mobile_number
      t.text :comment

      t.timestamps
    end
  end
end
