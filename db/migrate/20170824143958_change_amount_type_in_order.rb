class ChangeAmountTypeInOrder < ActiveRecord::Migration[5.0]
  def up
    change_column :orders, :amount, 'decimal USING CAST(amount AS decimal)', precision: 8, scale: 2
  end
 
  def down
    change_column :orders, :amount, :string
  end
end
