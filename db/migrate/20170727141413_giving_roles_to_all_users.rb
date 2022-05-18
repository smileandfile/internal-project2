class GivingRolesToAllUsers < ActiveRecord::Migration[5.0]
  def change
    all_access_roles = Role.create(name: "All Actions")
    User.user.each do |u|
      u.roles << all_access_roles
      u.save
    end
  end
end
