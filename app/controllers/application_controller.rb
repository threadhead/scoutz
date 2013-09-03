class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private
  def auth_and_time_zone
    authenticate_user!
    Time.zone = current_user.time_zone || "Pacific Time (US & Canada)"
    @units = current_user.units if current_user
  end

  # def unit_events_index(params)
  #   @limit = (params[:limit] || 5).to_i
  #   @unit = current_user.units.where(id: params[:unit_id]).first
  #   @events = @unit.events.from_today.by_start
  #   @all_events_count = @events.count
  #   @events = @events.limit(@limit).all
  # end

  # def calender_events(params)
  #   if params[:unit_ids]
  #     @units = Unit.where(id: params[:unit_ids].split(","))
  #   # else
  #   #   @units = current_user.units
  #   end
  #   @events = Event.joins(:unit).where(units: {id: @units})
  #   @events = @events.time_range(params[:start], params[:end]) if params[:start] && params[:end]
  # end


  # def event_finders
  #   @limit = (params[:limit] || 5).to_i

  #   # if params[:unit_id]
  #   #   @units = Unit.where(id: params[:unit_id])
  #   # end

  #   # @org_events = Hash.new
  #   # @units.each do |unit|

  #   #   @org_events.merge(org_events)
  #   # end


  #   if params[:unit_id]
  #     @unit = Unit.find(params[:unit_id])
  #     @events = @unit.events.by_start
  #   else
  #     @events = Event.joins(unit: :users).where(users: {id: current_user.id}).by_start
  #   end

  #   if params[:start] && params[:end]
  #     @events = @events.time_range(params[:start], params[:end])
  #   else
  #     @events = @events.from_today
  #   end
  # end

end
