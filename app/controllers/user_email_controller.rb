class UserEmailController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_user
  after_action :verify_authorized

  def edit
    authorize_user_email
    @is_current_users_record = editing_self?
  end

  def update
    authorize_user_email

    user_update = case
    when email_not_changed?
      flash[:notice] = 'You did not enter a different email address. Please enter an email different from the current, or cancel.'
      false

    when editing_self?
      flash[:notice] = 'Check your inbox for a confirmation email. You must confirm your email address change, or the change will not be made.'
      @user.update(user_params)


    else
      udt = @user.update_column(:email, user_params[:email])
      @user.touch
      flash[:notice] = "#{@user.name.possessive} email address was forcibly changed. No confirmation is required. A notification was sent to #{@user.email}."
      UserConfirmationsMailer.forced_email_change(@user, current_user, @unit).deliver_later
      udt
    end


    if user_update
      if @user.adult?
        redirect_to unit_adult_path(@unit, @user)
      else
        redirect_to unit_scout_path(@unit, @user)
      end

    else
      render action: 'edit'
    end
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = @unit.users.find(params[:id])
    end

    def editing_self?
      params[:id] == current_user.id.to_s
    end

    def email_not_changed?
      user_params[:email] == @user.email
    end

    def user_params
      if @user.adult?
        params.require(:adult).permit(:email)
      else
        params.require(:scout).permit(:email)
      end
    end

    def authorize_user_email
      @_pundit_policy_authorized = true
      @_policy_authorized = true

      unless UserEmailControllerPolicy.new(current_user, @user, @unit).update?
        error = Pundit::NotAuthorizedError.new('not allowed to edit the email of this user.')
        error.query, error.record, error.policy = 'update', @user, UserEmailControllerPolicy

        raise error
      end
    end

end
