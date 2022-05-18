class CreateEwayBillMultipleAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :eway_bill_multiple_auths do |t|
      t.references :ewaybill
      t.string :gstin
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string :auth_encrypted_sek
      t.string :auth_decrypted_sek
      t.string :app_key, limit: 1000000

      t.timestamps
    end
  end
end
