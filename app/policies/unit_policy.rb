class UnitPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    adult_admin
  end

  def create?
    false
  end

  def update?
    adult_admin
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
