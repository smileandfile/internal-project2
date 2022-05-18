class AddDurationToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :duration, :string
  end
end
