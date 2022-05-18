class AddTaxToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :sgst, :decimal, precision: 8, scale: 2
  	add_column :orders, :cgst, :decimal, precision: 8, scale: 2
  	add_column :orders, :igst, :decimal, precision: 8, scale: 2
    add_column :orders, :without_tax_amount, :decimal, precision: 8, scale: 2
  end
end
