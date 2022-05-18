require 'exceptions'

module RoleChecker
  def check_roles
    # return true if current_user.roles.where(name: "All Actions").present?
    return true if current_user.super_admin? || current_user.admin? || current_user.user?
    #RBACK need to set up again in more reliable way
    # raise RoleCheckFailedException.new(action_name, current_user) unless
    #   current_user.can_access_action(controller_name, action_name)
  end
end