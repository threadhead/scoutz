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
    adult_admin || users_signup? || event_owner? ||  adult_of_family?
  end

  def destroy?
    # users can delete their own signups, and adult admins and event owners
    adult_admin || users_signup? || event_owner? ||  adult_of_family?
  end

  def activity_consent_form?
    adult_admin || form_coordinator? || event_owner?
  end




  def users_signup?
    return false if record.user.nil? || user.nil?
    record.user.id == user.id
  end

  def adult_of_family?
    return false if user.nil? || !user.adult? || record.user.nil?
    return false unless record.event.unit.present?
    user.unit_family(record.event.unit).map(&:id).include?(record.user.id)
  end

  # def users_signup?
  #   if record.respond_to?(:id)
  #     EventSignup.where(id: record.id).where(user_id: user.scouts).exists?
  #   else
  #     true
  #   end
  # end

  def form_coordinator?
    record.event.form_coordinator?(user)
  end

  def event_owner?
    return false if record.nil?
    record.event.users.where(id: user.id).exists?
  end

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
