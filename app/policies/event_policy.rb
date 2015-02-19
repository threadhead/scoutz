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
    user_role_at_least_leader || event_owner?
  end

  def destroy?
    # users can delete their own events, and adult admins as well
    adult_admin || event_owner?
  end


  def add_signups?
    adult_leader_or_above || event_owner?
  end

  def calendar?
    user_role_at_least_basic
  end

  def email_attendees?
    user_role_at_least_leader || event_owner?
  end

  def sms_attendees?
    user_role_at_least_leader || event_owner?
  end

  def last_unit_meeting?
    update?
  end

  def print_roster?
    user_role_at_least_leader || event_owner?
  end


  def event_owner?
    record.users.where(id: user.id).exists?
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
