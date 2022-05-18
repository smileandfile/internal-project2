class UsersTokensReset < ActiveRecord::Migration[5.1]
  def change
    User.find_each do |user|
      user.uid = user.email
      user.tokens = nil
      user.save(validate: false)
    end
  end
end
