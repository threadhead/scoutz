class MeritBadgesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_merit_badge, only: [:show, :edit, :update, :destroy]
  before_action :set_unit
  after_action :verify_authorized

  def index
    authorize MeritBadge
    @merit_badges = MeritBadge.by_name.all
  end

  def show
    authorize @merit_badge
  end

  def new
    authorize MeritBadge
    # @merit_badge = MeritBadge.new
  end

  def edit
    authorize @merit_badge
  end

  def create
    authorize MeritBadge
    # @merit_badge = MeritBadge.new(merit_badge_params)
    # if @merit_badge.save
    #   redirect_to @merit_badge, notice: 'Merit badge was successfully created.'
    # else
    #   render :new
    # end
  end

  def update
    authorize @merit_badge
    if @merit_badge.update(merit_badge_params)
      @merit_badge.touch
      redirect_to unit_merit_badge_url(@unit, @merit_badge), notice: 'Merit badge was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @merit_badge
    # @merit_badge.destroy
    # redirect_to merit_badges_url, notice: 'Merit badge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merit_badge
      @merit_badge = MeritBadge.find(params[:id])
    end

    def set_unit
      @unit = current_user.units.where(id: params[:unit_id]).first
    end


    # Only allow a trusted parameter "white list" through.
    def merit_badge_params
      params.require(:merit_badge).permit(user_ids: [])
    end
end
