class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)
    if user.super_admin?
      can :manage, :all
      cannot :manage, Branch
      can :access, :rails_admin
    elsif user.admin?
      can_access_branch = Domain.where(user: user).branch_levels.present?
      entities = user.domain.entities
      gstins = Gstin.where(entity: entities)
      users = user.domain.domain_users
      user_ids = users.ids.push(user.id)

      can :manage, FileDownload, user: {id: user.id}
      can :read, Package
      can :create, User
      can :manage, User, id: user_ids
      can :create, Branch if can_access_branch
      cannot :destroy, User, id: user.id
      can :read, Domain, id: user.domain.id
      can :read, Order, user: {id: user.id}
      if user.domain&.package&.is_package_credit_type
        can [:read, :create], Gstin, entity: {id: entities.ids }
        can [:read, :create, :update], [Entity], domain: {id: user.domain.id}
      else
        can :manage, Gstin, entity: {id: entities.ids }
        can :manage, [Entity], domain: {id: user.domain.id}
      end
      can :manage, [Branch], gstin: {id: gstins.ids } if can_access_branch

      # For now only super admin can view audit logs
      # can :manage, GstAccessItem, domain: user.domain.name
    elsif user.user? && user.persisted?
      entity_gstin_ids = Gstin.where(entity: user.entities).pluck(:id)
      user_gstin_ids = user.gstins.pluck(:id)
      gstin_ids = entity_gstin_ids << user_gstin_ids

      # branch_ids = Branch.where("gstin_id = ? or id = ?", user.gstins.ids, user.branches.ids).ids
      can :manage, Entity, id: user.entities.ids
      can :manage, Gstin, id: gstin_ids
      can [:read], Domain, id: user.domain.id
      # can :manage, Branch, id: branch_ids
      can :manage, User, id: user.id

      # can view all entities in the domain
      can :read, Entity, domain: { id: user.domain.id }
      # can view all gstins in the domain
      can :read, Gstin, domain: { id: user.domain.id }
      # can view all users in the domain
      can :read, User, id: user.domain.domain_users.ids
      # can view all admin of domain
      can :read, User, id: user.domain.user.id
    else
    end

  end
end
