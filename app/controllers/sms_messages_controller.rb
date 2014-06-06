class SmsMessagesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_unit
  before_action :set_sms_message, only: [:show, :edit, :update, :destroy]
  before_action :set_send_to_lists, only: [:new, :edit, :update]

  # GET /sms_messages
  def index
    @sms_messages = SmsMessage.where(unit_id: @unit).where(user_id: current_user).includes(:sender).by_updated_at
    fresh_when last_modified: @sms_messages.maximum(:updated_at)
  end

  # GET /sms_messages/1
  def show
    fresh_when(@sms_message)
  end

  # GET /sms_messages/new
  def new
    options = {}
    options.merge!({send_to_option: 4, user_ids: params[:user_ids].split(',')}) if params[:user_ids]
    @sms_message = SmsMessage.new(options)
  end

  # GET /sms_messages/1/edit
  def edit
  end

  # POST /sms_messages
  def create
    @sms_message = SmsMessage.new(sms_message_params)

    if @sms_message.save
      @unit.sms_messages << @sms_message
      current_user.sms_messages << @sms_message
      SmsMessage.delay.dj_send_sms(@sms_message.id)
      redirect_to unit_sms_message_path(@unit, @sms_message), notice: 'SMS message was successfully created.'
    else
      set_send_to_lists
      render :new
    end
  end

  # PATCH/PUT /sms_messages/1
  def update
    if @sms_message.update(sms_message_params)
      redirect_to @sms_message, notice: 'SMS message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sms_messages/1
  def destroy
    @sms_message.destroy
    redirect_to sms_messages_url, notice: 'SMS message was successfully destroyed.'
  end

  private
    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end

    def set_send_to_lists
      @leaders = @unit.users.leaders.gets_sms_message.by_name_lf
      @sub_units = @unit.sub_units.by_name
      @unit_users = @unit.users.gets_sms_message.by_name_lf
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sms_message
      @sms_message = SmsMessage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sms_message_params
      params.require(:sms_message).permit(:user_id, :message, :send_to_option, {sub_unit_ids: []}, {user_ids: []})
    end
end
