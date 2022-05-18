class AddTurnoverPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :turnover_from, :string
    add_column :packages, :turnover_to, :string
  end
end
