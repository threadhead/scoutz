class EventSignupPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    false
  end

  def create?
    user_role_at_least_basic
  end

  def update?
    adult_admin || users_signup? || event_owner?
  end

  def destroy?
    # users can delete their own events, and adult admins as well
    adult_admin || users_signup? || event_owner?
  end



  def users_signup?
    EventSignup.where(id: record.id).where(scout_id: user.scouts).exists?
  end

  def event_owner?
    record.event.users.where(id: user.id).exists?
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
