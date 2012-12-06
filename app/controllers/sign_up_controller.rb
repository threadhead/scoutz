class SignUpController < ApplicationController
	layout 'full_width_fluid'

  def user
    @organization = Organization.new
  end

  def unit
  end

  def import
  end
end
