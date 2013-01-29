class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def auth_and_time_zone
    authenticate_user!
    Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
    @organizations = current_user.organizations if current_user
  end

  def event_finders
    @limit = (params[:limit] || 5).to_i
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
      @events = @organization.events.by_start
    else
      @events = Event.joins(organization: :users).where(users: {id: current_user.id}).by_start
    end
    if (params[:start] && params[:end])
      @events = @events.time_range(params[:start], params[:end])
    else
      @events = @events.from_today
    end


  end

end
