class PagesController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_page, except: [:index, :new, :create]
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

  def show_admin
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
      redirect_to show_admin_unit_page_url(@unit, @page), notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /pages/1
  def update
    authorize @page
    if @page.update(page_params)
      redirect_to show_admin_unit_page_url(@unit, @page), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /pages/1
  def destroy
    authorize @page
    @page.destroy
    redirect_to unit_pages_url(@unit), notice: 'Page was successfully deleted.'
  end

  def deactivate
    authorize @page
    @page.remove_from_list
    @page.deactivate!
    redirect_to unit_pages_url(@unit), notice: "The #{@page.title} page was successfully deactivated."
  end

  def activate
    authorize @page
    @page.activate!
    @page.insert_at(999999)
    @page.move_to_bottom
    redirect_to unit_pages_url(@unit), notice: "The #{@page.title} page was activated and moved to the bottom."
  end


  def move_higher
    authorize @page
    @page.move_higher
    set_pages
    render :index, notice: "The #{@page.title} page was moved up one position."
  end

  def move_lower
    authorize @page
    @page.move_lower
    set_pages
    render :index, notice: "The #{@page.title} page was moved down one position."
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
      params.require(:page).permit(:title, :body, :public, :front_page)
    end
end
