class AddPackageReferenceToSubPackage < ActiveRecord::Migration[5.0]
  def change
    add_reference :sub_packages, :package, index: true
  end
end
