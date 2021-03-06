class HealthFormsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_health_form, only: [:show, :edit, :update, :destroy]
  before_action :set_return
  after_action :verify_authorized

  def index
    # authorize HealthForm
    authorize_health_form
    @users = @unit.users.order(:type).by_name_lf
    @users_count = @unit.users.count
    if params[:search_typeahead] && !params[:search_typeahead].blank?
      @users = @users.name_contains(params[:search_typeahead])
      @searching = true
    end
    @searching = false
  end

  def show
    # authorize @health_form
    authorize_health_form
  end

  def new
    # authorize HealthForm
    authorize_health_form
    @user = User.find(params[:user_id])
    @health_form = HealthForm.new(user: @user, unit: @unit)
  end

  def edit
    # authorize @health_form
    authorize_health_form
  end

  def create
    # authorize HealthForm
    authorize_health_form
    @health_form = HealthForm.new(health_form_params)

    if @health_form.save
      redirect_to @return || unit_health_forms_url(@unit), notice: 'Health form was successfully created.'
    else
      render :new
    end
  end

  def update
    # authorize @health_form
    authorize_health_form

    if @health_form.update_attributes(health_form_params)
      redirect_to @return || unit_health_forms_url(@unit), notice: 'Health form was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # authorize @health_form
    authorize_health_form
    user = @health_form.user
    @health_form.destroy
    redirect_to unit_health_forms_url(@unit), notice: "#{user.name} health form was successfully removed."
  end



  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_health_form
      # @health_form = HealthForm.find(params[:id])
      @health_form = @unit.health_forms.where(id: params[:id]).first!
    end

    def set_return
      @return = params[:return].blank? ? nil : ERB::Util.h(params[:return])
    end

    # Only allow a trusted parameter "white list" through.
    def health_form_params
      params.require(:health_form).permit(:part_a_date, :part_b_date, :part_c_date, :florida_sea_base_date, :northern_tier_date, :philmont_date, :summit_tier_date, :user_id, :unit_id)
    end


    def authorize_health_form
      # https://github.com/elabs/pundit/blob/master/lib/pundit.rb
      # basically following the pundit.authorize method
      query = params[:action].to_s + '?'
      @_policy_authorized = true
      @_pundit_policy_authorized = true
      policy = HealthFormPolicy.new(current_user, @health_form, @unit)
      fail Pundit::NotAuthorizedError, 'not allowed to edit this health form' unless policy.public_send(query)
    end

end
