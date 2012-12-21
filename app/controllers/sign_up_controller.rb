class SignUpController < ApplicationController
	layout 'full_width_fluid'

  def user
    @organization = Organization.new
  end

  def new_unit
    @organization = Organization.new(params[:organization])
    @organization.sub_units.build
  end

  def create_unit
    @organization = Organization.new(params[:organization])
    if @organization.save
      redirect_to sign_up_new_sub_unit_path, notice: 'Organization was successfully created.'
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
