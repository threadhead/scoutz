class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def auth_and_time_zone
    authenticate_user!
    Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
    @organizations = current_user.organizations if current_user
  end

  # def organization_events_index(params)
  #   @limit = (params[:limit] || 5).to_i
  #   @organization = current_user.organizations.where(id: params[:organization_id]).first
  #   @events = @organization.events.from_today.by_start
  #   @all_events_count = @events.count
  #   @events = @events.limit(@limit).all
  # end

  # def calender_events(params)
  #   if params[:organization_ids]
  #     @organizations = Organization.where(id: params[:organization_ids].split(","))
  #   # else
  #   #   @organizations = current_user.organizations
  #   end
  #   @events = Event.joins(:organization).where(organizations: {id: @organizations})
  #   @events = @events.time_range(params[:start], params[:end]) if params[:start] && params[:end]
  # end


  # def event_finders
  #   @limit = (params[:limit] || 5).to_i

  #   # if params[:organization_id]
  #   #   @organizations = Organization.where(id: params[:organization_id])
  #   # end

  #   # @org_events = Hash.new
  #   # @organizations.each do |organization|

  #   #   @org_events.merge(org_events)
  #   # end


  #   if params[:organization_id]
  #     @organization = Organization.find(params[:organization_id])
  #     @events = @organization.events.by_start
  #   else
  #     @events = Event.joins(organization: :users).where(users: {id: current_user.id}).by_start
  #   end

  #   if params[:start] && params[:end]
  #     @events = @events.time_range(params[:start], params[:end])
  #   else
  #     @events = @events.from_today
  #   end
  # end

end
