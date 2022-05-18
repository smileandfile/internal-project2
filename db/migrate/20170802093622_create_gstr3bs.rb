class CreateGstr3bs < ActiveRecord::Migration[5.0]
  def change
    create_table :gstr3bs do |t|

      t.timestamps
    end
  end
end
