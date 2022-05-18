class AddOfflinePaymentDate < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :offline_payment_date, :datetime
    add_column :orders, :payment_mode_lock, :boolean, default: false
  end
end
