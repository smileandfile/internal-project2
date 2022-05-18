class CreateFileDownloadGstins < ActiveRecord::Migration[5.1]
  def change
    create_table :file_download_gstins do |t|
      t.string "gstin_number"
      t.string "state_code"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "auth_token"
      t.string "auth_encrypted_sek"
      t.string "auth_decrypted_sek"
      t.string "username"
      t.integer "user_id"
      t.integer "entity_id"
      t.integer "gsp_environment"
      t.datetime "registration_date"
      t.integer "dealer_type"
      t.bigint "turnover_last_year"
      t.bigint "turnover_current"
      t.integer "domain_id"
      t.string "endpoint_name"
      t.datetime "auth_expires_at"
      t.string "app_key", limit: 1000000
      t.datetime "auth_token_expires_at"
      t.datetime "server_time"
      t.integer "actual_time_of_token_expires"
      t.references :user
      t.references :branch
      t.references :entity
      
      t.timestamps
    end
  end
end