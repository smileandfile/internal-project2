class AddSekToEwaybill < ActiveRecord::Migration[5.1]
  def change
    add_column :ewaybills, :auth_encrypted_sek, :string
    add_column :ewaybills, :auth_decrypted_sek, :string
  end
end
