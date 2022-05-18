class CreateSnfSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :snf_settings do |t|
      t.text :whats_new
      t.text :faqs
      t.string :gstin_number
      t.timestamps

    end
  end
end
