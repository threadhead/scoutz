class Ckeditor::PicturePolicy < ApplicationPolicy
  # attr_reader :user, :picture

  # def initialize(user, picture)
  #   @user = user
  #   @picture = picture
  # end

  def index?
    true and ! @user.nil?
  end

  def create?
    true and ! @user.nil?
  end

  def destroy?
    @record.assetable_id == @user.id
  end
end
