class UserPolicy < ApplicationPolicy
  # by adding nothing we disable all controller actions
  # users should be accessed through their adult/scout controllers

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
