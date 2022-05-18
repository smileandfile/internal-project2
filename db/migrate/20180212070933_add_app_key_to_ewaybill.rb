class AddAppKeyToEwaybill < ActiveRecord::Migration[5.1]
  def change
    add_column :ewaybills, :app_key, :string, limit: 1000000
  end
end
