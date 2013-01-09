class AfterSignupController < ApplicationController
  include Wicked::Wizard

  steps :user_info, :unit_info

  def show
    @user = current_user
    @organization = nil
    render_wizard
  end

  def update
    @user = current_user

    case step
    when :user_info
      @user.attributes(params[:user])
      render_wizard @user

    when :unit_info
      @organization = Organization.find(params[:organization][:id])
      @organization.attributes(params[:organization])
      render_wizard @organization
    end
  end
end
