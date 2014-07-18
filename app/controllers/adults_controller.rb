class AdultsController < UsersController

  def index
    authorize Adult
    @users = @unit.adults.includes(:sub_unit, :scouts).by_name_lf
    # fresh_when last_modified: @users.maximum(:updated_at)
  end

  def new; super(Adult); end

  def create
    remove_new_phone_attribute
    @user = Adult.new(user_params)
    authorize @user

    if @user.save
      @unit.users << @user
      redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully created."
    else
      render action: 'new'
    end
  end

  def update
    authorize @user
    remove_new_phone_attribute
    params[:adult][:scout_ids] = @user.handle_relations_update(@unit, params[:adult][:scout_ids])

    if @user.update_attributes(user_params)
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

end
