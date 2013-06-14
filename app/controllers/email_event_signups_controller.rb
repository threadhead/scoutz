class EmailEventSignupsController < ApplicationController
  # NOTICE this is an UNAUTHENTICATED controller
  #
  # IMPORTANT do not allow access to data other than a single users signup!!!
  #

  layout 'unauth'

  def index
    if !set_user_event_scout_signup
      # raise ActionDispatch::RoutingError.new('Not Found')
      render 'public/404', status: 404

    elsif params[:cancel_reservation] == 'true'
      if @event_signup.new_record?
        flash[:alert] = "The signup you are trying to cancel is not available. If you meant to create a new signup, use the form below."
        render :new
      else
        flash[:info] = "Are you sure you want to cancel this signup?"
        render :edit
      end

      # existing signup, update with options from email
    elsif !@event_signup.new_record? && !select_custom_options
      # if @event_signup.update_attributes(params.extract!(*valid_keys).except(:comment))
      if @event_signup.update_attributes(email_event_signups_params(params))
        redirect_to event_email_event_signup_path(@event, @event_signup, event_token: params[:event_token], user_token: params[:user_token]), notice: "Signup changed."
      else
        flash[:error] = "Change failed. See below."
        render :edit
      end

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
      handle_event_signup_create
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
      raise ActionController::RoutingError.new('Not Found')
    end
  end


  def create
    if set_user_and_event
      handle_event_signup_create
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def new
    # you can't come here directly!!!
  end

  def destroy
    if set_user_event_scout_signup
      # @event_signup = EventSignup.find(params[:id])
      # @scout = @event_signup.scout
      create_activity :destroy
      @event_signup.destroy
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    if set_user_and_event
      @event_signup = EventSignup.find(params[:id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit
    # you can't come here directly!!!
  end

  private
    def email_event_signups_params(params)
      params.permit(:siblings_attending, :scouts_attending, :adults_attending, :scout_id, :comment)
    end

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
      record_params = params.has_key?(:event_signup) ? params[:event_signup] : params
      # @event_signup = @event.event_signups.build(record_params.extract!(*valid_keys))
      @event_signup = @event.event_signups.build(email_event_signups_params(record_params))

      if @event_signup.save
        create_activity :create
        redirect_to event_email_event_signup_path(@event, @event_signup, event_token: params[:event_token], user_token: params[:user_token]), notice: "Signup successful!"
      else
        flash[:error] = "Signup failed. See below."
        render :new
      end
    end

    def valid_keys
      [:siblings_attending, :scouts_attending, :adults_attending, :scout_id, :comment]
    end

    def create_activity(task)
      # @event_signup.create_activity task, owner: @user, unit_id: @event_signup.unit.id, parameters: {event_id: @event.id, scout_id: @event_signup.scout.id, created_at: Time.now}
    end
end
