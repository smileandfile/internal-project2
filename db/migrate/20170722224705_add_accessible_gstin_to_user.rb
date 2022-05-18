class AddAccessibleGstinToUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :gstins
  end
end
