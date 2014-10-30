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
    user.id == record.id || user_role_at_least_leader
  end

  def destroy?
    # adult_leader_or_above
    user.admin? && user.adult?
  end

  def send_welcome_reset_password?
    user.admin? && user.adult?
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
