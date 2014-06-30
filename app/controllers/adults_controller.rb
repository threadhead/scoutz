class AdultsController < ApplicationController
  etag { current_user.try :id }
  # etag { current_customer.id }

  before_action :auth_and_time_zone
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_unit

  def index
    @users = @unit.adults.includes(:sub_unit, :scouts).by_name_lf
    fresh_when last_modified: @users.maximum(:updated_at)
  end

  def show
    fresh_when(@user)
  end

  def new
    @user = Adult.new
  end

  def edit
    fresh_when(@user)
  end

  def create
    @user = Adult.new(user_params)

    respond_to do |format|
      if @user.save
        @unit.users << @user
        format.html { redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully created." }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    params[:adult][:scout_ids] = @user.handle_relations_update(@unit, params[:adult][:scout_ids])
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    user_name = @user.full_name
    respond_to do |format|
      format.html { redirect_to unit_adults_path(@unit), notice: "#{user_name}, and all associated data, was permanently deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Adult.find(params[:id])
    end

    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:adult).permit(:first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone, :birth, :rank, :leadership_position, :additional_leadership_positions, :sub_unit_id, :send_reminders, :adult_ids, {scout_ids: []}, :picture, :remove_picture, :email, :sms_number, :sms_provider, :blast_email, :blast_sms, :event_reminder_email, :event_reminder_sms, :signup_deadline_email, :signup_deadline_sms, :sms_message, :weekly_newsletter_email, :monthly_newsletter_email)
    end
end
