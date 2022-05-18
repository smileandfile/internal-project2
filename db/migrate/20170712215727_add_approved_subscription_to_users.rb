class AddApprovedSubscriptionToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :approved_subscription, :boolean, default: false
  end
end
