class MovePackageSubscriptionToDomain < ActiveRecord::Migration[5.0]
  def change
    remove_reference :users, :package, index: true
    remove_column :users, :package_start_date
    remove_column :users, :package_end_date
    remove_column :users, :approved_subscription

    add_reference :domains, :package, index: true
    add_column :domains, :package_start_date, :datetime
    add_column :domains, :package_end_date, :datetime
  end
end
