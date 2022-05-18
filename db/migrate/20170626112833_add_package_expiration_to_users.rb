class AddPackageExpirationToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :package_start_date, :datetime
  	add_column :users, :package_end_date, :datetime
  end
end
