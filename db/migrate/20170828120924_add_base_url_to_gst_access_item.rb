class AddBaseUrlToGstAccessItem < ActiveRecord::Migration[5.0]
  def change
    add_column :gst_access_items, :base_url, :string
  end
end
