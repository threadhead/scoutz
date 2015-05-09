class MeritBadgesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_merit_badge, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize MeritBadge
    @merit_badges = MeritBadge.by_name
    @merit_badges_count = MeritBadge.count
    if params[:search_typeahead] && !params[:search_typeahead].blank?
      @merit_badges = MeritBadge.name_contains(params[:search_typeahead]).by_name
      @searching = true
    end
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
    set_counselor_attributes
    # @merit_badge = MeritBadge.new(merit_badge_params)
    # if @merit_badge.save
    #   redirect_to @merit_badge, notice: 'Merit badge was successfully created.'
    # else
    #   render :new
    # end
  end

  def update
    authorize @merit_badge
    set_counselor_attributes(@merit_badge)
    # logger.info "params: #{pp params}"

    begin
      merit_badge_update = @merit_badge.update(merit_badge_params)
    rescue ActiveRecord::RecordNotUnique
      @merit_badge.errors.add(:base, 'Merit badges for each user muse be unique')
    end

    if merit_badge_update
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

    # Only allow a trusted parameter "white list" through.
    def merit_badge_params
      params.require(:merit_badge).permit(counselors_attributes: [:id, :user_id, :unit_id, :_destroy])
    end

    def set_counselor_attributes(merit_badge=nil)
      return unless params[:merit_badge].key?(:user_ids)
      user_ids = params[:merit_badge].extract!(:user_ids)

      params[:merit_badge][:counselors_attributes] = MeritBadge.create_counselors_attributes(
        merit_badge: merit_badge,
        unit: @unit,
        users_ids: user_ids['user_ids']
      )
    end

end
