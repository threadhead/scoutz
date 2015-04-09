class EmailGroupsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_email_group, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized


  def index
    authorize EmailGroup
    @email_groups = @unit.email_groups
  end

  def show
    authorize @email_group
  end

  def new
    authorize EmailGroup
    @email_group = EmailGroup.new
  end

  def edit
    authorize @email_group
  end

  def create
    @email_group = EmailGroup.new(email_group_params)
    @email_group.user = current_user
    @email_group.unit = @unit
    authorize @email_group

    if @email_group.save
      redirect_to unit_email_group_url(@unit, @email_group), notice: 'Email Group was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @email_group
    if @email_group.update(email_group_params)
      redirect_to unit_email_group_url(@unit, @email_group), notice: 'Email Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @email_group
    @email_group.destroy
    redirect_to unit_email_groups_url(@unit), notice: 'Email group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_group
      @email_group = @unit.email_groups.where(id: params[:id]).first!
    end

    # Only allow a trusted parameter "white list" through.
    def email_group_params
      params.require(:email_group).permit(:name, :description, users_ids: [])
    end
end
