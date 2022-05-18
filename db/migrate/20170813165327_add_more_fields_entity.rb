class AddMoreFieldsEntity < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :address, :text
    add_column :entities, :pan_number, :string
  end
end
