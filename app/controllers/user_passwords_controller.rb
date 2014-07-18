class UserPasswordsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_user
  after_action :verify_authorized

  def edit
    authorize UserPasswordsController
  end

  def update
    authorize UserPasswordsController
    if @user.update_with_password(user_params)
      sign_in @user, :bypass => true
      redirect_to unit_adult_path(@unit, @user), notice: "Your password was successfully updated."
    else
      clean_up_passwords @user
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end


    def user_params
      if current_user.adult?
        params.require(:adult).permit(:current_password, :password, :password_confirmation)
      else
        params.require(:scout).permit(:current_password, :password, :password_confirmation)
      end
    end
end
