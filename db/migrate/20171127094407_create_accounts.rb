class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|

      t.references :domain
      t.string :description
      t.integer :gstin_allowed_left
      t.decimal :per_gstin_amount, :precision => 20, :scale => 10
      t.decimal :credits, :precision => 20, :scale => 10
      t.timestamps
    end
  end
end
