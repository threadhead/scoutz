class HealthFormPolicy < ApplicationPolicy
  def index?
    user_role_at_least_leader
  end

  def show?
    user_role_at_least_leader || health_form_owner?
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    user_role_at_least_leader
  end

  def destroy?
    user_role_at_least_leader
  end


  def health_form_owner?
    # puts "health form: #{record.inspect}"
    # puts "current_users health form: #{record.user_id == user.id}"
    # puts "current_users scouts health form: #{user.unit_scouts(record.unit).where(users: {id: record.user_id}).exists?}"
    record.user_id == user.id || user.unit_scouts(record.unit).where(users: {id: record.user_id}).exists?
  end


  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     scope
  #   end
  # end
end
