class UnsubscribeController < ApplicationController
  layout 'dialog_dark_modal'

  before_action :set_user
  # before_action :set_unit

  def event_reminder_email
    @user.update_attribute(:event_reminder_email, false)
  end

  def weekly_newsletter_email
    @user.update_attribute(:weekly_newsletter_email, false)
  end

  def blast_email
    @user.update_attribute(:blast_email, false)
  end

  private

    def set_user
      if params.key?(:id)
        @user = User.find_by!(signup_token: params[:id])
      else
        fail ActionController::RoutingError, 'Not Found'
      end
    end
end
