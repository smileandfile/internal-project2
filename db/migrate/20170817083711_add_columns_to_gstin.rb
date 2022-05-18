class AddColumnsToGstin < ActiveRecord::Migration[5.0]
  def change
    add_column :gstins, :dealer_type, :integer
    add_column :gstins, :turnover_last_year, :integer, limit: 8
    add_column :gstins, :turnover_current, :integer, limit: 8
  end
end
