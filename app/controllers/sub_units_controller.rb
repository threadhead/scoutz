class SubUnitsController < ApplicationController
  before_action :auth_and_time_zone

  def index
    @sub_units = SubUnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sub_units }
    end
  end

  def show
    @sub_unit = SubUnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_unit }
    end
  end

  def new
    @sub_unit = SubUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_unit }
    end
  end

  def edit
    @sub_unit = SubUnit.find(params[:id])
  end

  def create
    @sub_unit = SubUnit.new(params[:sub_unit])

    respond_to do |format|
      if @sub_unit.save
        format.html { redirect_to @sub_unit, notice: 'Sub unit was successfully created.' }
        format.json { render json: @sub_unit, status: :created, location: @sub_unit }
      else
        format.html { render action: "new" }
        format.json { render json: @sub_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @sub_unit = SubUnit.find(params[:id])

    respond_to do |format|
      if @sub_unit.update_attributes(params[:sub_unit])
        format.html { redirect_to @sub_unit, notice: 'Sub unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sub_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_unit = SubUnit.find(params[:id])
    @sub_unit.destroy

    respond_to do |format|
      format.html { redirect_to sub_units_url }
      format.json { head :no_content }
    end
  end
end
