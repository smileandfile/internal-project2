class AddPackageToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_reference :users, :package, index: true
  end
end
