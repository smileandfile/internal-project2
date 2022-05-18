class CreateEwaybills < ActiveRecord::Migration[5.1]
  def change
    create_table :ewaybills do |t|

      t.string :party_name
      t.string :mobile_number
      t.string :email
      t.string :address
      t.string :gstin
      t.string :client_id
      t.string :client_secret
      t.integer :bill_request_count
      t.integer :token_request_count
      t.integer :is_active
      t.string :auth_token
      t.datetime :auth_token_expires_at
        
      t.timestamps
    end
  end
end
