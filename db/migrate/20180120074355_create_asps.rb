class CreateAsps < ActiveRecord::Migration[5.1]
  def change
    create_table :asps do |t|
      t.string :party_name
      t.string :mobile_number
      t.string :email, unique: true
      t.string :address
      t.string :username, unique: true
      t.string :secret_password
      t.integer :gstin_request_count
      t.integer :token_request_count
      t.integer :is_active

      t.timestamps
    end
  end
end
