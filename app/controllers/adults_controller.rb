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

    respond_to do |format|
      if @user.save
        @unit.users << @user
        format.html { redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully created." }
        # format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @user
    remove_new_phone_attribute
    params[:adult][:scout_ids] = @user.handle_relations_update(@unit, params[:adult][:scout_ids])
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to unit_adult_path(@unit, @user), notice: "#{@user.full_name} was successfully updated." }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @user
    @user.destroy
    user_name = @user.full_name
    respond_to do |format|
      format.html { redirect_to unit_adults_path(@unit), notice: "#{user_name}, and all associated data, was permanently deleted." }
      # format.json { head :no_content }
    end
  end

end
