class CreateSubPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_packages do |t|
      t.integer :turnover_from, limit: 8
      t.integer :turnover_to, limit: 8
      t.integer :annual, limit: 5
      t.integer :half_yearly, limit: 5
      t.integer :quarterly, limit: 5
      t.timestamps
    end
  end
end
