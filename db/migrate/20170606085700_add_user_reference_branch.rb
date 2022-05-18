class AddUserReferenceBranch < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :branch, index: true
  end
end
