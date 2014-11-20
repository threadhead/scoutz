class HealthFormsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_health_form, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize HealthForm
    @users = @unit.users.order(:type).by_name_lf
    # @health_forms_count = HealthForm.count
    # if params[:search_typeahead] && !params[:search_typeahead].blank?
    #   @health_forms = HealthForm.name_contains(params[:search_typeahead]).by_name
    #   @searching = true
    # end
    @searching = false

  end

  def show
    authorize @health_form
  end

  def new
    authorize HealthForm
    # @health_form = HealthForm.new
  end

  def edit
    authorize @health_form
  end

  def create
    authorize HealthForm
    set_counselor_attributes
    # @health_form = HealthForm.new(merit_badge_params)
    # if @health_form.save
    #   redirect_to @health_form, notice: 'Merit badge was successfully created.'
    # else
    #   render :new
    # end
  end

  def update
    authorize @health_form

    if @health_form.update_attributes(health_form_params)
      redirect_to unit_health_forms_url(@unit), notice: 'Health form was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @health_form
    # @health_form.destroy
    # redirect_to merit_badges_url, notice: 'Merit badge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_health_form
      @health_form = HealthForm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def health_form_params
      params.require(:health_form).permit(:part_a_date, :part_b_date, :part_c_date, :florida_sea_base_date, :northern_tier_date, :philmont_date, :summit_tier_date, :user_id, :unit_id)
    end

end
