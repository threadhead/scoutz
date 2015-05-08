class ScoutsController < UsersController

  def index
    authorize Scout
    @users = @unit.scouts.includes(:sub_unit, :adults).by_name_lf
    @users_count = @unit.adults.count
    if params[:search_typeahead] && !params[:search_typeahead].blank?
      @users = @users.name_contains(params[:search_typeahead])
      @searching = true
    end

    # fresh_when last_modified: @users.maximum(:updated_at)
  end

  def new; super(Scout); end

  def edit
    authorize_scout
  end


  def create
    remove_new_phone_attribute
    @user = Scout.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        @unit.users << @user
        format.html { redirect_to unit_scout_path(@unit, @user), notice: "#{@user.full_name} was successfully created." }
        # format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize_scout
    remove_new_phone_attribute
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to unit_scout_path(@unit, @user), notice: "#{@user.full_name} was successfully updated." }
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
      format.html { redirect_to unit_scouts_path(@unit), notice: "#{user_name}, and all associated data, was permanently deleted."  }
      # format.json { head :no_content }
    end
  end

  def send_welcome_reset_password
    super
    redirect_to unit_scout_path(@unit, @user), notice: "Welcome email was sent to #{@user.name}. Their account has been deactivated until they confirm."
  end

  private

    def authorize_scout
      # https://github.com/elabs/pundit/blob/master/lib/pundit.rb
      # basically following the pundit.authorize method
      query = params[:action].to_s + '?'
      @_policy_authorized = true
      @_pundit_policy_authorized = true
      policy = ScoutPolicy.new(current_user, @user, @unit)
      raise Pundit::NotAuthorizedError.new('not allowed to edit this scout') unless policy.public_send(query)
    end

end
