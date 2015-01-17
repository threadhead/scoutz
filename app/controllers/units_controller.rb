class UnitsController < ApplicationController
  before_action :auth_and_time_zone
  # before_action :set_unit, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized


  def index
    authorize Unit
    @units = @unit
  end

  def show
    authorize @unit
  end

  def new
    @unit = Unit.new
    authorize @unit
  end

  def edit
    authorize @unit
  end

  def create
    authorize @unit
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to @unit, notice: 'Unit was successfully created.'
    else
      render action: :new
    end
  end

  def update
    authorize @unit
    @unit = Unit.find(params[:id])

    if @unit.update(unit_params)
      redirect_to @unit, notice: 'Unit was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    authorize @unit
    # @unit.destroy

    redirect_to units_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = current_user.units.where(id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:city, :state, :time_zone, :unit_type, :unit_number, :sub_units_attributes)
    end
end
