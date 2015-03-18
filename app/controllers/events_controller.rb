class EventsController < ApplicationController
  # respond_to :html, :js
  before_action :auth_and_time_zone
  before_action :set_event, only: [:show, :edit, :update, :destroy, :email_attendees, :sms_attendees]
  before_action :set_new_event, only: [:new, :edit]
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
    elsif params.key?(:months)
      @events = @events.now_plus_months(params[:months]).by_start
      # @events = @events.by_start
      @end_month = (Time.zone.now + params[:months].to_i.months).end_of_month
    else
      @events = @events.from_today.by_start.page(params[:page]).per(10)
    end
    @pages = @unit.pages.front_pages


    respond_to do |format|
      format.html do
        if params[:commit] == 'Print'
          render :index_print, layout: 'print'
        else
          render :index
        end
      end
      format.json { render json: @events }
      format.js
    end
    # fresh_when last_modified: @events.maximum(:updated_at)
  end

  def calendar
    authorize Event
    if params[:print]
      render :calendar_print, layout: 'print'
    else
      render :calendar
    end
  end

  def last_unit_meeting
    authorize Event
    last_unit_meeting = Event.last_unit_meeting(@unit)
    # last_unit_meeting = Event.first
    # ap last_unit_meeting
    respond_to do |format|
      format.json { render json: last_unit_meeting.to_copy_meeting_json }
    end
  end

  def show
    authorize @event
    if params[:print]
      render :show_print, layout: 'print'
    else
      render :show
    end
  end

  def new
    start_time = params.key?(:start_at) ? Time.zone.parse("#{params[:start_at]}T08:00:00") : Time.zone.now.to_next_hour
    @event = Event.new(start_at: start_time, end_at: (start_time + 1.hour), user_ids: [current_user.id])
    @sub_unit_ids = []
    authorize @event
  end

  def edit
    authorize @event
    @unit = @event.unit
    @sub_unit_ids = @event.sub_unit_ids
  end

  def create
    @event = @unit.events.build(event_params)
    authorize @event

    if @event.save
      redirect_to unit_event_url(@unit, @event), notice: 'Event was successfully created.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      set_new_event
      render :new
    end
  end

  def update
    authorize @event
    if @event.update_attributes(event_params)
      redirect_to unit_event_url(@unit, @event), notice: 'Event was successfully updated.'
    else
      @sub_unit_ids = sub_unit_ids(params[:event][:sub_unit_ids])
      set_new_event
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
      # @event = Event.find(params[:id])
      @event = @unit.events.where(id: params[:id]).first!
    end

    def set_new_event
      last_unit_meeting = Event.last_unit_meeting(@unit)
      @last_unit_meeting_start_at = last_unit_meeting.try(:start_at) || Time.zone.now.to_next_hour
      @last_unit_meeting_end_at = last_unit_meeting.try(:end_at) || Time.zone.now.to_next_hour + 1.hour
    end

    def event_params
      params.require(:event).permit(
        :end_at_date, :end_at_time, :start_at_date, :start_at_time, :signup_deadline_date, :signup_deadline_time,
        :attire, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :unit_id, :send_reminders, :signup_required, :start_at, {user_ids: []}, :message, :type_of_health_forms, :consent_required, {sub_unit_ids: []}, {form_coordinator_ids: []})
    end


    def sub_unit_ids(params)
      if params
        params.map{|id| id.to_i}
      else
        []
      end
    end

end
