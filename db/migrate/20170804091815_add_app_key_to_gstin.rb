class AddAppKeyToGstin < ActiveRecord::Migration[5.0]
  def change
    add_column :gstins, :app_key, :string
  end
end
