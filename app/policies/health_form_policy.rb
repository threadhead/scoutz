class HealthFormPolicy < ApplicationPolicy
  def index?
    adult_leader_or_above
  end

  def show?
    adult_leader_or_above || health_form_owner?
  end

  def create?
    adult_leader_or_above
  end

  def update?
    adult_leader_or_above
  end

  def destroy?
    adult_leader_or_above
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
