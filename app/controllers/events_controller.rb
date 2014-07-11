class EventsController < ApplicationController
  respond_to :html, :js
  before_action :auth_and_time_zone
  before_action :set_event, only: [:show, :edit, :update, :destroy, :email_attendees, :sms_attendees]
  after_action :verify_authorized

  def index
    # event_finders
    # if params[:unit_id]
    #   @unit = Unit.find(params[:unit_id])
    #   @events = @unit.events.by_start
    # else
    #   @events = @events.joins(unit: :users).where(users: {id: current_user.id}).by_start
    # end
    # @events = @events.time_range(params[:start], params[:end]) if (params[:start] && params[:end])
    authorize Event
    if params[:unit_id]
      @limit = (params[:limit] || 5).to_i
      @unit = current_user.units.where(id: params[:unit_id]).first
    else
      @events = Event.joins(unit: :users).where(users: {id: current_user.id}).by_start
      @events = @events.time_range(params[:start], params[:end]) if (params[:start] && params[:end])
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
      format.js
    end
    # fresh_when last_modified: @events.maximum(:updated_at)
  end

  def calendar
    calendar_events(params)
    render json: @events
  end

  def show
    if stale?(@event)
      @event_signups = @event.user_signups(current_user)
      @event_rosters = EventSignup.for_event(@event).by_scout_name_lf
      respond_with(@event)
    end
    authorize @event
  end

  def new
    @unit = params[:unit_id] ? Unit.find(params[:unit_id]) : Unit.first
    @event = Event.new(unit_id: @unit.id, start_at: Time.zone.now.to_next_hour, end_at: 1.hour.from_now.to_next_hour)
    @sub_unit_ids = []
    authorize @event
  end

  def edit
    authorize @event
    @unit = @event.unit
    @sub_unit_ids = @event.sub_unit_ids
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    # @unit = Unit.find(params[:unit_id]) if params[:unit_id]
    # @event = @unit.events.build(params[:event])

    if @event.save
      current_user.events << @event
      redirect_to @event, notice: 'Event was successfully created.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      render :new
    end
  end

  def update
    authorize @event
    if @event.update_attributes(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      render :edit
    end
  end

  def destroy
    authorize @event
    @event.destroy

    redirect_to events_url
  end

  def email_attendees
    authorize @event
    redirect_to new_unit_email_message_path(@event.unit,
                                            event_ids: @event.id,
                                            user_ids: @event.event_signup_user_ids.join(',')
                                            )
  end

  def sms_attendees
    authorize @event
    redirect_to new_unit_sms_message_path(@event.unit,
                                          user_ids: @event.event_signup_user_ids.join(',')
                                          )
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:attire, :end_at, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :unit_id, :send_reminders, :signup_deadline, :signup_required, :start_at, :user_ids, :message, {sub_unit_ids: []})
    end


    def sub_unit_ids(params)
      if params
        params.map{|id| id.to_i}
      else
        []
      end
    end

end
