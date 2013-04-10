class EmailEventSignupsController < ApplicationController
  # NOTICE this is an UNAUTHENTICATED controller
  #
  # IMPORTANT do not allow access to data other than a single users signup!!!
  #
  before_filter :set_user_event_scout_signup, only: [:index, :show, :edit, :update, :destroy]

  def index
    if @event_signup.blank?
      @event.event_signups.build()
    else
    end

  end

  def update
  end

  def create
  end

  def new
  end

  def destroy
  end

  def show
  end

  def edit
  end

  private
    def set_user_event_scout_signup
      @user = User.find_by_signup_token(params[:user_token])
      Time.zone = @user.time_zone || "Pacific Time (US & Canada)"
      @event = Event.find_by_signup_token(params[:event_token])
      @scout = Scout.find(params[:scout_id])
      @event_signup = EventSignup.where(scout_id: @scout.id, event_id: @event.id).first
    end
end
