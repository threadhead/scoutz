class EmailEventSignupsController < ApplicationController
  # NOTICE this is an UNAUTHENTICATED controller
  #
  # IMPORTANT do not allow access to data other than a single users signup!!!
  #

  layout 'unauth'

  def index
    if !set_user_event_scout_signup
      render status: 404

      # user can edit their existing signup
    elsif !@event_signup.new_record?
      flash[:info] = "The deadline for signup has passed, but you can change your existing signup." if @event.after_signup_deadline?
      render :edit

      # no existing signup, deadline PASSED
    elsif @event_signup.new_record? && @event.after_signup_deadline?
      flash[:error] = "The deadline for signup has passed."
      render :new

      # no existing signup, custom options
    elsif @event_signup.new_record? && select_custom_options
      render :new

      # user selected an option from email, deadline has NOT passed
    elsif @event_signup.new_record? && !@event.after_signup_deadline?
      handle_event_signup_create(params)
    end

  end

  def update
    if set_user_and_event
      @event_signup = EventSignup.find(params[:id])
      if @event_signup.update_attributes(params[:event_signup])
        redirect_to event_email_event_signup_path(@event, @event_signup, event_token: params[:event_token], user_token: params[:user_token]), notice: "Signup changed."
      else
        flash[:error] = "Change failed. See below."
        render :edit
      end

    else
      render status: 404
    end
  end

  def create
    if set_user_and_event
      handle_event_signup_create
    else
      render status: 404
    end
  end

  def new
    # you can't come here directly!!!
  end

  def destroy
  end

  def show
    if set_user_and_event
      @event_signup = EventSignup.find(params[:id])
    else
      render status: 404
    end
  end

  def edit
  end

  private
    def set_user_event_scout_signup
      return false unless set_user_and_event
      Time.zone = @user.time_zone || "Pacific Time (US & Canada)"
      @scout = Scout.find(params[:scout_id])
      @event_signup = EventSignup.where(scout_id: @scout.id, event_id: @event.id).first
      @event_signup = EventSignup.new(scout_id: @scout.id) if @event_signup.blank?
      return true
    end

    def set_user_and_event
      @user = User.find_by_signup_token(params[:user_token])
      @event = Event.find_by_signup_token(params[:event_token])
      !@user.blank? && !@event.blank?
    end

    def edit_options
      params[:scouts_attending] == '0' && params[:adults_attending] == '0' && params[:siblings_attending] == '0'
    end

    def select_custom_options
      !params.has_key?(:scouts_attending) &&
      !params.has_key?(:adults_attending) &&
      !params.has_key?(:siblings_attending)
    end

    def handle_event_signup_create
      valid_keys = [:siblings_attending, :scouts_attending, :adults_attending, :scout_id, :comment]
      record_params = params.has_key?(:event_signup) ? params[:event_signup] : params
      @event_signup = @event.event_signups.build(record_params.extract!(*valid_keys))

      if @event_signup.save
        redirect_to event_email_event_signup_path(@event, @event_signup, event_token: params[:event_token], user_token: params[:user_token]), notice: "Signup successful!"
      else
        flash[:error] = "Signup failed. See below."
        render :new
      end
    end

end
