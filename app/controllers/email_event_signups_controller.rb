class EmailEventSignupsController < ApplicationController
  # NOTICE this is an UNAUTHENTICATED controller
  #
  # IMPORTANT do not allow access to data other than a single users signup!!!
  #
  # before_filter :set_user_event_scout_signup, only: [:index]
  before_filter :set_event_signup, only: [:show, :edit, :update, :destroy]
  layout 'unauth'

  def index
    valid_keys = [:siblings_attending, :scouts_attending, :adults_attending, :scout_id]

    if !set_user_event_scout_signup
      render status: 404

      # user selected other options for signup, with existing signup
    elsif edit_options(params) && !@event_signup.blank?
      render :edit

      # user selected other options for signup, no existing signup
    elsif edit_options(params) && @event_signup.blank?
      flash[:warning] = "The deadline for signup has passed. Sorry." if @event.after_signup_deadline?
      render :new

      # user selected an option from email, deadline has NOT passed
    elsif @event_signup.blank? && !@event.after_signup_deadline?
      @event_signup = @event.event_signups.build(params.extract(*valid_keys))
      if @event_signup.save
        redirect_to event_email_event_signup_path(@event, @event_signup), notice: "Signup successful!"
      else
        render :new, warning: "Signup failed. See below."
      end

      # user selected an option from email, deadline PASSED
    elsif @event_signup.blank? && @event.after_signup_deadline?
      render :new, warning: "The deadline for signup has passed. Sorry."
    end

  end

  def update
  end

  def create
  end

  def new
    # you can't come here directly!!!
  end

  def destroy
  end

  def show
    @event = Event.find(params[:event_id])
    @event_signup = EventSignup.find(params[:id])
  end

  def edit
  end

  private
    def set_event_signup
      @event = Event.find(params[:event_id])
      @event_signup = EventSignup.find(params[:id])
    end

    def set_user_event_scout_signup
      @user = User.find_by_signup_token(params[:user_token])
      @event = Event.find_by_signup_token(params[:event_token])
      return false if @user.blank? || @event.blank?
      Time.zone = @user.time_zone || "Pacific Time (US & Canada)"
      @scout = Scout.find(params[:scout_id])
      @event_signup = EventSignup.where(scout_id: @scout.id, event_id: @event.id).first
    end

    def edit_options(params)
      params[:scouts_attending] == '0' && params[:adults_attending] == '0' && params[:siblings_attending] == '0'
    end

    def no_attending_values(params)
      !params.has_key?(:scouts_attending) &&
      !params.has_key?(:adults_attending) &&
      !params.has_key?(:siblings_attending)
    end

end
