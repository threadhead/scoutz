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

    respond_to do |format|
      if @email_message.save
        @unit.email_messages << @email_message
        current_user.email_messages << @email_message
        format.html { redirect_to unit_email_message_path(@unit, @email_message), notice: 'Email message was successfully created.' }
        format.json { render json: @email_message, status: :created, location: @email_message }
      else
        4.times { @email_message.email_attachments.build }
        format.html { render action: "new" }
        format.json { render json: @email_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @email_message.update_attributes(email_message_params)
        format.html { redirect_to unit_email_message_path(@unit, @email_message), notice: 'Email message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @email_message.destroy
    respond_to do |format|
      format.html { redirect_to email_messages_url }
      format.json { head :no_content }
    end
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
