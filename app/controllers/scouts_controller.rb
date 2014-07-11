class ScoutsController < ApplicationController
  etag { current_user.try :id }
  # etag { current_customer.id }

  before_action :auth_and_time_zone
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_unit
  after_action :verify_authorized

  def index
    authorize Scout
    @users = @unit.scouts.includes(:sub_unit, :adults).by_name_lf
    fresh_when last_modified: @users.maximum(:updated_at)
  end

  def show
    authorize @user
    fresh_when(@user)
  end

  def new
    @user = Scout.new
    authorize @user
  end

  def edit
    authorize @user
  end

  def create
    @user = Scout.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        @unit.users << @user
        format.html { redirect_to unit_scout_path(@unit, @user), notice: 'Scout was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to unit_scout_path(@unit, @user), notice: 'Scout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to unit_scouts_path(@unit) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Scout.find(params[:id])
    end

    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end

    def user_params
      params.require(:scout).permit(:first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone, :birth, :rank, :leadership_position, :additional_leadership_positions, :sub_unit_id, :send_reminders, :adult_ids, {scout_ids: []}, :picture, :remove_picture, :email, :role)
    end
end
