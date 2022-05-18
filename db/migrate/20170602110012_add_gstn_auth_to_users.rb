class AddGstnAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gstn_auth_token, :string
    add_column :users, :gstn_auth_expiry, :string
    add_column :users, :gstn_auth_encrypted_sek, :string
    add_column :users, :gstn_auth_decrypted_sek, :string
    add_column :users, :gstn_username, :string
  end
end
