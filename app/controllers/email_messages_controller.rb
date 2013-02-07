class EmailMessagesController < ApplicationController
  before_filter :auth_and_time_zone
  before_filter :set_unit
  before_filter :set_email_message, only: [:show, :edit, :update, :destroy]


  def index
    @email_messages = current_user.email_messages.by_updated_at
  end

  def show
  end

  def new
    @email_message = EmailMessage.new
    5.times { @email_message.email_attachments.build }
  end

  def edit
  end

  def create
    @email_message = EmailMessage.new(email_message_params)

    respond_to do |format|
      if @email_message.save
        @unit.email_messages << @email_message
        current_user.email_messages << @email_message
        format.html { redirect_to unit_email_message_path(@unit, @email_message), notice: 'Email message was successfully created.' }
        format.json { render json: @email_message, status: :created, location: @email_message }
      else
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
      params[:email_message]
    end

end
