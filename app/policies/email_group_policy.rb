class EmailGroupPolicy < ApplicationPolicy
  def index?
    user_role_at_least_leader
  end

  def show?
    user_role_at_least_leader
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    user_role_at_least_leader
  end

  def destroy?
    user_role_at_least_leader
  end


end
