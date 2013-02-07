class SignUpController < ApplicationController
	layout 'full_width_fluid'

  def user
    @unit = Unit.new
  end

  def new_unit
    @unit = Unit.new(params[:unit])
    @unit.sub_units.build
  end

  def create_unit
    @unit = Unit.new(params[:unit])
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
end
