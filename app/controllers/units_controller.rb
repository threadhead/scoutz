class UnitsController < ApplicationController
  def index
    @units = Unit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @units }
    end
  end

  def show
    @unit = Unit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unit }
    end
  end

  def new
    @unit = Unit.new(params[:unit])
  end

  def edit
    @unit = Unit.find(params[:id])
  end

  def create
    @unit = Unit.new(params[:unit])

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render json: @unit, status: :created, location: @unit }
      else
        format.html { render action: "new" }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @unit = Unit.find(params[:id])

    respond_to do |format|
      if @unit.update_attributes(params[:unit])
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to units_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:city, :state, :time_zone, :unit_type, :unit_number, :sub_units_attributes)
    end
end
