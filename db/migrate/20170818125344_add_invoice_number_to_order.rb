class AddInvoiceNumberToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :invoice_number, :string, index: true, unique: true
  end
end
