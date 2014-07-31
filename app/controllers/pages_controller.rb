class PagesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_page, only: [:show, :edit, :update, :destroy, :move_higher, :move_lower]
  after_action :verify_authorized


  # GET /pages
  def index
    authorize Page
    set_pages
  end

  # GET /pages/1
  def show
    authorize @page
  end

  # GET /pages/new
  def new
    authorize Page
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    authorize @page
  end

  # POST /pages
  def create
    @page = @unit.pages.build(page_params.merge({user_id: current_user.id}))
    authorize @page

    if @page.save
      redirect_to [@unit, @page], notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /pages/1
  def update
    authorize @page
    if @page.update(page_params)
      redirect_to [@unit, @page], notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /pages/1
  def destroy
    authorize @page
    @page.destroy
    redirect_to unit_pages_url(@unit), notice: 'Page was successfully destroyed.'
  end


  def move_higher
    authorize @page
    @page.move_higher
    set_pages
    render :index
  end

  def move_lower
    authorize @page
    @page.move_lower
    set_pages
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    def set_pages
      @pages = @unit.pages
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:postion, :title, :body, :public)
    end
end
