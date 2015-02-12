class UserEmailControllerPolicy < ApplicationPolicy

  def update?
    adult_admin || current_user_record?
  end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
