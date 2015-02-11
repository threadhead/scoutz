class UserEmailController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_user
  after_action :verify_authorized

  def edit
    authorize UserEmailController
  end

  def update
    authorize UserEmailController
    user_update = if user_params[:email] == @user.email
      false
    elsif editing_self?
      @user.update(user_params)
    else
      return false unless current_user.role_at_least(:admin)
      @user.update_column(:email, user_params[:email])
    end

    if user_update
      flash[:notice] = if editing_self?
         "Check your inbox for a confirmation email. You must confirm your email address change, or the change will not happen. "
      else
        "#{@user.name} email address was forcibly changed. No confirmation is required."
      end

      redirect_to unit_adult_path(@unit, @user)
    else
      if !email_changed?
        flash[:notice] = 'You did not enter a email address. Please enter a different email or cancel.'
      end
      render action: 'edit'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def editing_self?
      params[:id] == current_user.id.to_s
    end

    def email_changed?
      user_params[:email] != @user.email
    end

    def user_params
      if current_user.adult?
        params.require(:adult).permit(:email)
      else
        params.require(:scout).permit(:email)
      end
    end

end
