class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def auth_and_time_zone
    authenticate_user!
    Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
    @organizations = current_user.organizations if current_user
  end

end
