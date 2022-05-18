class AddExpiryToPackages < ActiveRecord::Migration[5.0]
  def change
  	add_column :packages, :expiry_duration, :string
  end
end
