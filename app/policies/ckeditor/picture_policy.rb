class Ckeditor::PicturePolicy < ApplicationPolicy
  def index?
    true && !user.nil?
  end

  def create?
    true && !user.nil?
  end

  def destroy?
    record.user_id == user.id
  end
end
