class EmailGroupsController < ApplicationController
  before_action :set_email_group, only: [:show, :edit, :update, :destroy]

  # GET /email_groups
  def index
    @email_groups = EmailGroup.all
  end

  # GET /email_groups/1
  def show
  end

  # GET /email_groups/new
  def new
    @email_group = EmailGroup.new
  end

  # GET /email_groups/1/edit
  def edit
  end

  # POST /email_groups
  def create
    @email_group = EmailGroup.new(email_group_params)

    if @email_group.save
      redirect_to @email_group, notice: 'Email group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /email_groups/1
  def update
    if @email_group.update(email_group_params)
      redirect_to @email_group, notice: 'Email group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /email_groups/1
  def destroy
    @email_group.destroy
    redirect_to email_groups_url, notice: 'Email group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_group
      @email_group = EmailGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def email_group_params
      params.require(:email_group).permit(:unit_id, :user_ids, :user_id)
    end
end
