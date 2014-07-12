class SignUpController < ApplicationController
	layout 'full_width_fluid'

  def user
    @unit = Unit.new
  end

  def new_unit
    @unit = Unit.new(unit_type: 'Cub Scouts', unit_number: '999')
    # @unit = Unit.new(unit_params)
    @unit.sub_units.build
  end

  def create_unit
    remove_new_sub_unit_attributes
    @unit = Unit.new(unit_params)
    if @unit.save
      current_user.units << @unit
      redirect_to sign_up_new_sub_unit_path, notice: 'Unit was successfully created.'
    else
      render :new_unit
    end
  end

  def new_sub_unit
  end

  def create_sub_unit
  end

  def import
  end

  private
    def remove_new_sub_unit_attributes
      params[:unit][:sub_units_attributes].delete('new_sub_unit')
    end

    def unit_params
      params.require(:unit).permit(:unit_type, :unit_number, :city, :state, :time_zone, sub_units_attributes: [])
    end

end
