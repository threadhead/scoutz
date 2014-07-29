class AdultsController < UsersController

  def index
    authorize Adult
    @users = @unit.adults.includes(:sub_unit, :scouts).by_name_lf
    @users_count = @unit.adults.count
    if params[:search_typeahead] && !params[:search_typeahead].blank?
      @users = @users.name_contains(params[:search_typeahead])
      @searching = true
    end
    # fresh_when last_modified: @users.maximum(:updated_at)
  end

  def new; super(Adult); end

  def create
    remove_new_phone_attribute
    set_counselor_attributes
    @user = Adult.new(user_params)
    authorize @user

    begin
      user_save = @user.save
    rescue ActiveRecord::RecordNotUnique
      @user.errors.add(:base, "Merit badges for each user muse be unique")
    end


    if user_save
      @unit.users << @user
      redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully created."
    else
      render action: 'new'
    end
  end

  def update
    authorize @user
    remove_new_phone_attribute
    set_counselor_attributes(@user)
    params[:adult][:scout_ids] = @user.handle_relations_update(@unit, params[:adult][:scout_ids])

    begin
      user_update = @user.update(user_params)
    rescue ActiveRecord::RecordNotUnique
      @user.errors.add(:base, "Merit badges for each user muse be unique")
    end

    if user_update
      redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully updated."
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @user
    user_name = @user.full_name
    @user.destroy
    redirect_to unit_adults_path(@unit), notice: "#{user_name}, and all associated data, was permanently deleted."
  end

  private
    def set_counselor_attributes(user=nil)
      return unless params[:adult].has_key?(:merit_badge_ids)
      merit_badge_ids = params[:adult].extract!(:merit_badge_ids)
      params[:adult][:counselors_attributes] = User.create_counselors_attributes(
                                                                       user: user,
                                                                       unit: @unit,
                                                                       merit_badge_ids: merit_badge_ids['merit_badge_ids']
                                                                       )
    end


end
