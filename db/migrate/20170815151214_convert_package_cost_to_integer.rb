class ConvertPackageCostToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :packages, :cost, 'integer USING CAST(cost AS integer)'
  end
end
