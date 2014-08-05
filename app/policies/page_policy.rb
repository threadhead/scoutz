class PagePolicy < ApplicationPolicy
  def index?
    user_role_at_least_leader
  end

  def show?
    user_role_at_least_basic || record.public
  end

  def show_admin?
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

  def move_higher?
    user_role_at_least_leader
  end

  def move_lower?
    user_role_at_least_leader
  end


  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
