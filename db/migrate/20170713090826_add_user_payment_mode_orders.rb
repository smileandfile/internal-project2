class AddUserPaymentModeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :user_payment_mode, :integer
  end
end
