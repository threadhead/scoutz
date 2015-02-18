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
    adult_admin || event_owner? || users_signup?
  end

  def destroy?
    # users can delete their own signups, and adult admins ad event owners
    adult_admin || event_owner? || users_signup?
  end

  def activity_consent_form?
    adult_admin || form_coordinator? || event_owner?
  end

  def users_signup?
    if record.respond_to?(:id)
      EventSignup.where(id: record.id).where(scout_id: user.scouts).exists?
    else
      true
    end
  end

  def form_coordinator?
    record.event.form_coordinator?(user)
  end

  def event_owner?
    if record
      record.event.users.where(id: user.id).exists?
    else
      false
    end
  end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
