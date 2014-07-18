class EditPasswordsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_user
  after_action :verify_authorized

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to unit_adult_path(@unit, @user), notice: "Your password was successfully updated."
    else
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end


    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
