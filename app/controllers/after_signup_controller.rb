class AfterSignupController < ApplicationController
  include Wicked::Wizard

  steps :user_info, :unit_info

  def show
    @user = current_user
    @unit = nil
    render_wizard
  end

  def update
    @user = current_user

    case step
    when :user_info
      @user.attributes(params[:user])
      render_wizard @user

    when :unit_info
      @unit = Unit.find(params[:unit][:id])
      @unit.attributes(params[:unit])
      render_wizard @unit
    end
  end
end
