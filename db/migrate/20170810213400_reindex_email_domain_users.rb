class ReindexEmailDomainUsers < ActiveRecord::Migration[5.0]
  def up
    remove_index :users, :email
    remove_index :users, [:uid, :provider]
    add_index :users, [:email, :domain_id], unique: true
  end

  def down
    remove_index :users, [:email, :domain_id]
    add_index :users, [:uid, :provider]
    add_index :users, :email, unique: true
  end
end
