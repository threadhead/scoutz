class EventsController < ApplicationController
  before_filter :auth_and_time_zone

  def index
    # event_finders
    # if params[:organization_id]
    #   @organization = Organization.find(params[:organization_id])
    #   @events = @organization.events.by_start
    # else
    #   @events = @events.joins(organization: :users).where(users: {id: current_user.id}).by_start
    # end
    # @events = @events.time_range(params[:start], params[:end]) if (params[:start] && params[:end])
    if params[:organization_id]
      @limit = (params[:limit] || 5).to_i
      @organization = current_user.organizations.where(id: params[:organization_id]).first
    else
      @events = Event.joins(organization: :users).where(users: {id: current_user.id}).by_start
      @events = @events.time_range(params[:start], params[:end]) if (params[:start] && params[:end])
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
      format.js
    end
  end

  def calendar
    calendar_events(params)
    render json: @events
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @organization = params[:organization_id] ? Organization.find(params[:organization_id]) : Organization.first
    @event = Event.new(start_at: Time.zone.now.to_next_hour, end_at: 1.hour.from_now.to_next_hour)
  end

  def edit
    @event = Event.find(params[:id])
    @organization = @event.organization
  end

  def create
    @event = Event.new(params[:event])
    # @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    # @event = @organization.events.build(params[:event])

    if @event.save
      redirect_to events_url, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to events_url, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_url
  end

  private
    def set_tz
      Time.zone = "Arizona"
    end
end
