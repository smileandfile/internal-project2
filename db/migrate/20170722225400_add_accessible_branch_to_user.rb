class AddAccessibleBranchToUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :branches
  end
end
