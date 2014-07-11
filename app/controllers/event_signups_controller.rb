class EventSignupsController < ApplicationController
  before_action :auth_and_time_zone, except: [:from_email]
  before_action :set_event_signup, only: [:show, :edit, :update, :destroy]
  before_action :set_event, except: [:from_email, :edit, :update]
  after_action :verify_authorized

  def index
    authorize EventSignup
    @event_signups = EventSignup.all
  end

  def show
    authorize @event_signup
  end

  def new
    @event_signup = EventSignup.new(scout_id: params[:scout_id], event_id: params[:event_id])
    authorize @event_signup
    render :edit
  end

  def edit
    authorize @event_signup
  end

  def create
    @event_signup = EventSignup.new(event_signup_params)
    authorize @event_signup

    respond_to do |format|
      if @event_signup.save
        create_activity(:create)
        # format.html { redirect_for_signups }
        # format.json { render json: @event_signup, status: :created, location: @event_signup }
        format.js   { js_update_success }
      else
        # format.html { redirect_for_signups }
        # format.json { render json: @event_signup.errors, status: :unprocessable_entity }
        format.js   { render :edit }
      end
    end
  end


  def update
    authorize @event_signup

    respond_to do |format|
      if @event_signup.update_attributes(event_signup_params)
        flash[:info] = "#{@event_signup.scout.full_name}'s sign up changed."

        # format.html { redirect_for_signups }
        # format.json { head :no_content }
        format.js   { js_update_success }
      else
        # format.html { redirect_for_signups }
        # format.json { render json: @event_signup.errors, status: :unprocessable_entity }
        format.js   { render :edit }
      end
    end
  end

  def destroy
    authorize @event_signup
    flash[:info] = "#{@event_signup.scout.full_name}'s sign up cancelled."
    create_activity(:destroy)
    @event_signup.destroy
    respond_to do |format|
      # format.html { redirect_to (event_submit? ? event_url(@event) : event_signups_url) }
      # format.json { head :no_content }
      format.js   { js_update_success }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_signup
      @event_signup = EventSignup.find(params[:id])
    end

    def set_event
      @event = Event.find(params[:event_id]) if params[:event_id]
    end

    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end

    def set_signups_rosters(event)
      @event_signups = event.user_signups(current_user)
      set_event_rosters(event)
    end

    def set_event_rosters(event)
      @event_rosters = EventSignup.for_event(event).by_scout_name_lf
    end

    def js_update_success
      set_signups_rosters(@event_signup.event)
      render :update_success
    end


    # def redirect_for_signups
    #   if @event_signup.valid?
    #     flash[:notice] = "#{@event_signup.scout.first_name}#{in_create? ? ' signed up!' : "'s sign up updated."}"
    #     redirect_to (event_submit? ? event_url(@event) : @event_signup)
    #   else
    #     if event_submit?
    #       set_signups_rosters
    #       render 'events/show'
    #     else
    #       render (in_create? ? :new : :edit)
    #     end
    #   end
    # end

    def event_submit?
      params.has_key?('event_signup_in_event_commit')
    end

    def in_create?
      self.action_name.downcase == 'create'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_signup_params
      params.require(:event_signup).permit(:adults_attending, :comment, :scouts_attending, :siblings_attending, :scout_id, :event_id)
    end

    def create_activity(task)
      @event_signup.create_activity task, owner: current_user, unit_id: @event_signup.unit.id, parameters: {event_id: @event_signup.event.id, scout_id: @event_signup.scout.id}
    end

end
