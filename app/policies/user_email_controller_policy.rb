class UserEmailControllerPolicy < ApplicationPolicy

  def update?;  true;   end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
