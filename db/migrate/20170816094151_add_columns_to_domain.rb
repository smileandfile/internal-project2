class AddColumnsToDomain < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :company_name, :string
    add_column :domains, :gstin_number, :string
  end
end
