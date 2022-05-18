class RemoveDomainUnusedColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :domains, :firm_name
    remove_column :domains, :gstin
  end
end
