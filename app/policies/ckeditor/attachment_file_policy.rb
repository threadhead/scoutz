class Ckeditor::AttachmentFilePolicy < ApplicationPolicy
  # attr_reader :user, :attachment

  # def initialize(user, attachment)
  #   @user = user
  #   @attachment = attachment
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
