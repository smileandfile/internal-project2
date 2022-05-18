class AddDomainReferenceUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :domain, index: true
  end
end
