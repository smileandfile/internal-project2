class AddColumnToRole < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :name, :string
    add_column :roles, :parent_id, :integer
    add_column :roles, :allowed_actions, :string, array: true, default: []
  end
end
