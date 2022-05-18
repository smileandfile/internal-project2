class MoveColumnsDomainToOrder < ActiveRecord::Migration[5.0]
  def change
    remove_column :domains, :company_name, :string
    remove_column :domains, :gstin_number, :string
    remove_column :domains, :pan_number, :string
    add_column :orders, :gstin_number, :string
    add_column :orders, :pan_number, :string
  end
end
