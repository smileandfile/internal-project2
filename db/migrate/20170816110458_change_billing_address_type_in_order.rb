class ChangeBillingAddressTypeInOrder < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :billing_address, :text
  end
end
