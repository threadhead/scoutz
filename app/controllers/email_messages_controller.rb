class EmailMessagesController < ApplicationController
  before_filter :auth_and_time_zone
  before_filter :set_unit
  before_filter :set_email_message, only: [:show, :edit, :update, :destroy]


  def index
    @email_messages = EmailMessage.where(unit_id: @unit).where(user_id: current_user).includes(:sender).by_updated_at
  end

  def show
  end

  def new
    options = {}
    options.merge!({send_to_option: 4, user_ids: params[:user_ids].split(',')}) if params[:user_ids]
    options.merge!({event_ids: params[:event_ids].split(',')}) if params[:event_ids]
    @email_message = EmailMessage.new(options)
    4.times { @email_message.email_attachments.build }
  end

  def edit
  end

  def create
    @email_message = @unit.email_messages.build(email_message_params)

    if @email_message.save
      @unit.email_messages << @email_message
      current_user.email_messages << @email_message
      @email_message.delay.send_email
      redirect_to unit_email_message_path(@unit, @email_message), notice: 'Email message was successfully created.'
    else
      4.times { @email_message.email_attachments.build }
      render action: "new"
    end
  end

  def update
    if @email_message.update_attributes(email_message_params)
      redirect_to unit_email_message_path(@unit, @email_message), notice: 'Email message was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @email_message.destroy
      redirect_to email_messages_url
  end


  private
    def set_email_message
      @email_message = EmailMessage.find(params[:id])
    end

    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_message_params
      # params.require(:email_message).permit(:subject, :message)
      filter_params(params[:email_message])
    end

    def filter_params(params)
      case params[:send_to_option]
      when '1', '2' # entire unit or all leaders
        params.except(:sub_unit_ids, :user_ids)
      when '3' # selected sub_units
        params.except(:user_ids)
      when '4' # selected users
        params.except(:sub_unit_ids)
      end

    end

end
