class MeritBadgePolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def create?
    false
  end

  def update?
    user_role_at_least_leader
  end

  def destroy?
    false
  end


  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
