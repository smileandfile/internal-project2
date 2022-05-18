class CreateAccountEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :account_entries do |t|

      t.references :account
      t.string :description 
      t.decimal :amount_deducted, :precision => 20, :scale => 10
      
      t.timestamps
    end
  end
end
