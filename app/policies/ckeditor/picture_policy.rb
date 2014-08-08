class Ckeditor::PicturePolicy < ApplicationPolicy
  def index?
    true and ! user.nil?
  end

  def create?
    true and ! user.nil?
  end

  def destroy?
    record.user_id == user.id
  end
end
