class ChangeColumnStateIntegerToString < ActiveRecord::Migration[5.0]
  def change
    change_column :gstins, :state_code, :string
  end
end
