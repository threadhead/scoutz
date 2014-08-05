module SentientController
  extend ActiveSupport::Concern

  included do
    before_action do |controller|
      User.current = controller.send(:current_user) # if current_user
    end
  end

  private
  def set_current_user
    User.current = current_user if current_user
  end

end
