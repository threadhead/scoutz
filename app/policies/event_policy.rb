class EventPolicy < ApplicationPolicy
  def index?
    user_role_at_least_basic
  end

  def show?
    user_role_at_least_basic
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    user_role_at_least_leader || users_event?
  end

  def destroy?
    # users can delete their own events, and adult admins as well
    adult_admin || users_event?
  end


  def calendar?
    user_role_at_least_basic
  end

  def email_attendees?
    user_role_at_least_leader || users_event?
  end

  def sms_attendees?
    user_role_at_least_leader || users_event?
  end



  def users_event?
    record.users.where(id: user.id).exists?
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
