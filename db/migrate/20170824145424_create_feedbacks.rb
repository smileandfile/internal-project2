class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :domain
      t.string :email
      t.string :mobile_number
      t.text :comment

      t.timestamps
    end
  end
end
