class ScoutPolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def create?
    adult_leader_or_above
  end

  def update?
    # can update themself, or need to be an adult leader
    current_user_record? || user_role_at_least_leader || my_scout?
  end

  def destroy?
    # adult_leader_or_above
    user.admin? && user.adult?
  end

  def send_welcome_reset_password?
    user.admin? && user.adult?
  end

  def edit_email?
    adult_admin || current_user_record? || my_scout?
  end



  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
