class MeritBadgesController < ApplicationController
  before_action :set_merit_badge, only: [:show, :edit, :update, :destroy]

  # GET /merit_badges
  def index
    @merit_badges = MeritBadge.all
  end

  # GET /merit_badges/1
  def show
  end

  # GET /merit_badges/new
  def new
    @merit_badge = MeritBadge.new
  end

  # GET /merit_badges/1/edit
  def edit
  end

  # POST /merit_badges
  def create
    @merit_badge = MeritBadge.new(merit_badge_params)

    if @merit_badge.save
      redirect_to @merit_badge, notice: 'Merit badge was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /merit_badges/1
  def update
    if @merit_badge.update(merit_badge_params)
      redirect_to @merit_badge, notice: 'Merit badge was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /merit_badges/1
  def destroy
    @merit_badge.destroy
    redirect_to merit_badges_url, notice: 'Merit badge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merit_badge
      @merit_badge = MeritBadge.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def merit_badge_params
      params.require(:merit_badge).permit(:name, :mb_org_url, :mb_org_worksheet_pdf_url, :mb_org_worksheet_doc_url)
    end
end
