class EventsController < ApplicationController
  # respond_to :html, :js
  before_action :auth_and_time_zone
  before_action :set_event, only: [:show, :edit, :update, :destroy, :email_attendees, :sms_attendees]
  after_action :verify_authorized

  def index
    authorize Event
    # this was used the the combined dashboard_list and dashboard_calendar
    # if params[:unit_id]
    #   @limit = (params[:limit] || 5).to_i
    #   @unit = current_user.units.where(id: params[:unit_id]).first
    # else
    #   @events = Event.joins(unit: :users).where(users: {id: current_user.id}).by_start
    # end

    @events = Event.joins(unit: :users).where(units: {id: @unit.id}).where(users: {id: current_user.id}).includes(:unit)

    if params.key?(:start) && params.key?(:end)
      @events = @events.time_range(params[:start], params[:end])
    else
      @events = @events.from_today.by_start.page(params[:page]).per(10)
    end
    @pages = @unit.pages.front_pages


    respond_to do |format|
      format.html
      format.json { render json: @events }
      format.js
    end
    # fresh_when last_modified: @events.maximum(:updated_at)
  end

  def calendar
    authorize Event
  end

  def show
    authorize @event
    @event_signups = @event.user_signups(current_user)
    @event_rosters = EventSignup.for_event(@event).by_scout_name_lf
    # respond_with(@event)
  end

  def new
    start_time = params.key?(:start_at) ? Time.zone.parse("#{params[:start_at]}T08:00:00") : Time.zone.now.to_next_hour
    @event = Event.new(start_at: start_time, end_at: (start_time + 1.hour))
    @sub_unit_ids = []
    authorize @event
  end

  def edit
    authorize @event
    @unit = @event.unit
    @sub_unit_ids = @event.sub_unit_ids
  end

  def create
    # @event = Event.new(event_params)
    @event = @unit.events.build(event_params)
    authorize @event

    if @event.save
      current_user.events << @event
      redirect_to unit_event_url(@unit, @event), notice: 'Event was successfully created.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      render :new
    end
  end

  def update
    authorize @event
    if @event.update_attributes(event_params)
      redirect_to unit_event_url(@unit, @event), notice: 'Event was successfully updated.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      render :edit
    end
  end

  def destroy
    authorize @event
    @event.destroy

    redirect_to unit_events_url(@unit), notice: 'Event was successfully destroyed.'
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
      params.require(:event).permit(
        :end_at_date, :end_at_time, :start_at_date, :start_at_time, :signup_deadline_date, :signup_deadline_time,
        :attire, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :unit_id, :send_reminders, :signup_required, :start_at, :user_ids, :message, :type_of_health_forms, :consent_required, {sub_unit_ids: []}, {form_coordinator_ids: []})
    end


    def sub_unit_ids(params)
      if params
        params.map{|id| id.to_i}
      else
        []
      end
    end

end
