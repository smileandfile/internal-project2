class AddGstnAuthGstins < ActiveRecord::Migration[5.0]
  def change
    add_column :gstins, :auth_token, :string
    add_column :gstins, :auth_expiry, :string
    add_column :gstins, :auth_encrypted_sek, :string
    add_column :gstins, :auth_decrypted_sek, :string
    add_column :gstins, :username, :string
  end
end
