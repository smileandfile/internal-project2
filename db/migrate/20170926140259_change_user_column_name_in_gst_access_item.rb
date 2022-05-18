class ChangeUserColumnNameInGstAccessItem < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :gst_access_items, :user, :user_id
  end

  def self.down
    rename_column :gst_access_items, :user_id, :user
  end
end

