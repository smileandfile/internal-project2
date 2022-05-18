class AddActiveSubscriptionOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :subscription, :integer
  end
end
