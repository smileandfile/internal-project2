class CreateCommonApiLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :common_api_logs do |t|
      t.datetime "requested_at"
      t.string "gstin"
      t.json "request_headers"
      t.string "api_name"
      t.datetime "response_at"
      t.string "response_type"
      t.string "invalid_reason"
      t.json "response_headers"
      t.string "username"
      t.string "base_url"
  
      t.timestamps
    end
  end
end
