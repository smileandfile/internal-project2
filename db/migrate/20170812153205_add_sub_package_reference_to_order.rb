class AddSubPackageReferenceToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :sub_package, index: true
  end
end
