class SmsMessagesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_sms_message, only: [:show, :edit, :update, :destroy]
  before_action :set_send_to_lists, only: [:new, :edit, :update]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @sms_messages = policy_scope(SmsMessage.where(unit_id: @unit)).includes(:sender).by_updated_at
    # fresh_when last_modified: @sms_messages.maximum(:updated_at)
  end

  def show
    authorize @sms_message
    # fresh_when(@sms_message)
  end

  def new
    options = {}
    options.merge!({send_to_option: 4, user_ids: params[:user_ids].split(',')}) if params[:user_ids]
    @sms_message = SmsMessage.new(options)
    authorize @sms_message
  end

  def edit
    authorize @sms_message
  end

  def create
    @sms_message = SmsMessage.new(sms_message_params)
    authorize @sms_message

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

  def update
    authorize @sms_message
    if @sms_message.update(sms_message_params)
      redirect_to @sms_message, notice: 'SMS message was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @sms_message
    @sms_message.destroy
    redirect_to sms_messages_url, notice: 'SMS message was successfully destroyed.'
  end

  private
    def set_send_to_lists
      @leaders = @unit.users.unit_leaders(@unit).gets_sms_message.by_name_lf
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
