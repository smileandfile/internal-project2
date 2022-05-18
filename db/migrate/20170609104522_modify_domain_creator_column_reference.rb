class ModifyDomainCreatorColumnReference < ActiveRecord::Migration[5.0]
  def change
    remove_reference :users, :domain
    add_reference :domains, :user, index: true
  end
end
