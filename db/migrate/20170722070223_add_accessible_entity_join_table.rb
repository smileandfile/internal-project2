class AddAccessibleEntityJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :entities
    # add_column :users_entities, :id, :primary_key
  end
end
