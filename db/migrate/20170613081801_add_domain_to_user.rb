class AddDomainToUser < ActiveRecord::Migration[5.0]
  def change
    remove_reference :domains, :user, index: true
    add_reference :users, :domain
  end
end
