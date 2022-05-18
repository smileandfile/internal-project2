class UpdateGstAccessItem < ActiveRecord::Migration[5.0]
  def change
    add_column :gst_access_items, :user_email, :string
    rename_column :gst_access_items, :payload_size, :request_payload_size
    add_column :gst_access_items, :response_payload_size, :integer
  end
end
