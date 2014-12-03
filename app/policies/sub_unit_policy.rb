class SubUnitPolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    user_role_at_least_leader
  end

  def destroy?
    adult_admin
  end


  def has_no_scouts?
    record.scouts.count == 0
  end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
