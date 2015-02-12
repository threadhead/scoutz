class UserEmailControllerPolicy < ApplicationPolicy

  def update?
    adult_admin || current_user_record? || my_scout?
  end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
