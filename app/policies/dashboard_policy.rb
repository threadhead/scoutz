class DashboardPolicy < ApplicationPolicy
  def index?; user_role_at_least_basic; end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
