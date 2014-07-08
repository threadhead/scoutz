class EventPolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def new?
    user_role_at_least_leader
  end

  def edit?
    user_role_at_least_leader
  end

  def destroy?
    user_role_at_least_leader
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    user_role_at_least_leader
  end

  def email_attendees?
    user_role_at_least_leader
  end

  def sms_attendees?
    user_role_at_least_leader
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
