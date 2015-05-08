class SmsMessagePolicy < ApplicationPolicy
  def index?
    # everyone can see their own messages
    true
  end

  def show?
    users_message? || adult_admin
  end

  def create?
    user_role_at_least_leader
  end

  def update?
    users_message? || adult_admin
  end

  def destroy?
    # users can delete their own messages, and adult admins as well
    users_message? || adult_admin
  end


  def users_message?
    record.sender.id == user.id
  end



  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
