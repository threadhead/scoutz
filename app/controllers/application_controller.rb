class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def auth_and_time_zone
    authenticate_user!
    # set_current_user
    Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
    @controller_namespace = current_user.role
  end

end
