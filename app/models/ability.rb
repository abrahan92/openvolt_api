# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # Abilities for role :super_admin
    if user.has_role?(:super_admin)
      can :manage, :all
    end

    # Abilities for role :admin
    if user.has_role?(:admin)
      can :read, [User, Role]
    end
  end
end