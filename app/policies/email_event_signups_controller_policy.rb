class EmailEventSignupsControllerPolicy < ApplicationPolicy

  def index?;   true;   end
  def show?;    true;   end
  def create?;  true;   end
  def update?;  true;   end
  def destroy?; true;   end

  def new?;     false;  end
  def edit?;    false;  end



  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
