class AdultPolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def new?
    adult_leader_or_above
  end

  def edit?
    user.id == record.id || adult_leader_or_above
  end

  def destroy?
    # adult_leader_or_above
    user.admin?
  end

  def create?
    adult_leader_or_above
  end

  def update?
    user.id == record.id || adult_leader_or_above
  end



  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
