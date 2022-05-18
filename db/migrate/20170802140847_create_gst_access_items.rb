class CreateGstAccessItems < ActiveRecord::Migration[5.0]
  def change
    create_table :gst_access_items do |t|
      t.string :username
      t.string :domain
      t.datetime :requested_at
      t.string :gstin
      t.string :return_period
      t.json :request_headers
      t.string :api_name
      t.integer :payload_size
      t.string :transaction_id
      t.string :ip_address
      t.datetime :response_at
      t.string :response_type
      t.string :invalid_reason
      t.json :response_headers
      t.string :reference_id
    end
  end
end
