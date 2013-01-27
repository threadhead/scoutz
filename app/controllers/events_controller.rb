class EventsController < ApplicationController
  before_filter :auth_and_time_zone

  def index
    @organization = Organization.first
    @events = @organization.events.by_start
    @events = @events.time_range(params[:start], params[:end]) if params[:start] && params[:end]
    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @organization = params[:organization_id] ? Organization.find(params[:organization_id]) : Organization.first
    @event = Event.new(start_at: Time.zone.now, end_at: Time.zone.now, signup_deadline: Time.zone.now)
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
