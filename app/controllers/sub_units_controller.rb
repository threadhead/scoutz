class SubUnitsController < ApplicationController
  before_action :auth_and_time_zone
  before_action :set_sub_unit, only: [:show, :edit, :update, :destroy]

  def index
    authorize SubUnit
    @sub_units = @unit.sub_units.order(:name)
  end

  def show
    authorize @sub_unit
  end

  def new
    authorize SubUnit
    @sub_unit = SubUnit.new(unit: @unit)
  end

  def edit
    authorize @sub_unit
  end

  def create
    authorize SubUnit
    @sub_unit = SubUnit.new(sub_unit_params)

    if @sub_unit.save
      @sub_unit.unit << @unit
      redirect_to @sub_unit, notice: 'Sub unit was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @sub_unit
    if @sub_unit.update(sub_unit_params)
      redirect_to @sub_unit, notice: 'Sub unit was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @sub_unit
    @sub_unit.destroy

    redirect_to sub_units_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_unit
      @sub_unit = SubUnit.find(params[:id])
    end

    def sub_unit_params
      params.require(:sub_unit).permit(:name, :description)
    end


end
