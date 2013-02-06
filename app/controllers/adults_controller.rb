class AdultsController < ApplicationController
  before_filter :auth_and_time_zone
  before_filter :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :set_organization

  def index
    @users = @organization.adults.by_name_lf
  end

  def show
  end

  def new
    @user = Adult.new
  end

  def edit
  end

  def create
    @user = Adult.new(user_params)

    respond_to do |format|
      if @user.save
        @organization.users << @user
        format.html { redirect_to organization_adult_path(@organization, @user), notice: 'Adult was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to organization_adult_path(@organization, @user), notice: 'Adult was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to organization_adults_path(@organization) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Adult.find(params[:id])
    end

    def set_organization
      @organization = current_user.organizations.where(id: params[:organization_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # params.require(:user).permit(:name, :email)
      params[:adult]
    end
end
