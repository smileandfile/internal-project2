class ChangeGstinAppKeyColumnSize < ActiveRecord::Migration[5.1]
  def change
    change_column :gstins, :app_key, :string, limit: 1000000
  end
end
