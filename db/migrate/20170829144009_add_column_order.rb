class AddColumnOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :utr_number, :string
    add_column :orders, :bank_name, :string
    add_column :orders, :date_remittance, :datetime
    add_column :orders, :cheque_number, :string
  end
end
