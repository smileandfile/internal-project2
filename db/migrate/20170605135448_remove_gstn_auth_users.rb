class RemoveGstnAuthUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :gstn_auth_token
    remove_column :users, :gstn_auth_expiry
    remove_column :users, :gstn_auth_encrypted_sek
    remove_column :users, :gstn_auth_decrypted_sek
    remove_column :users, :gstn_username
  end
end