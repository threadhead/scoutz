class ApplicationPolicy < Struct.new(:user, :record, :unit)

  def index?;       false;     end
  def show?;        false;     end
  def create?;      false;     end
  def new?;         create?;   end
  def update?;      false;     end
  def edit?;        update?;   end
  def destroy?;     false;     end
  def deactivate?;  update?;   end
  def activate?;    update?;   end

  def user_role_at_least_basic
    user.role_at_least(:basic)
  end

  def user_role_at_least_leader
    user.role_at_least(:leader)
  end

  def adult_leader_or_above
    user.adult? && user_role_at_least_leader
  end

  def adult_admin
    user.admin? && user.adult?
  end

  def my_scout?
    return false if unit.nil?
    # user.unit_scouts(record.unit).where(users: {id: record.user_id}).exists?
    user.unit_scouts(unit).pluck(:id).include? record.id
  end

  def current_user_record?
    return false unless record.is_a?(Adult) || record.is_a?(Scout)
    user.id == record.id
  end


  def scope
    Pundit.policy_scope!(user, record.class)
  end
end
