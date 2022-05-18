class AddMoreColumnsDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :firm_name, :string
    add_column :domains, :address, :text
    add_column :domains, :pan_number, :string
    add_column :domains, :gstin, :string
    add_column :domains, :firm_turnover, :string
  	add_column :domains, :is_active, :boolean, default: false
    add_index :domains, :name, unique: true
  end
end
