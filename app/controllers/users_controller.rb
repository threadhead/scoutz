class UsersController < ApplicationController
  # etag { current_user.try :id }

  before_action :auth_and_time_zone
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def show
    authorize @user
    # logger.info "CONTROLLER_TYPE: #{controller_type}"
  end

  def edit
    authorize @user
  end

  def new(ar_model)
    @user = ar_model.new
    authorize @user
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def remove_new_phone_attribute
      params[controller_type][:phones_attributes].delete('new_phone')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(controller_type).permit(
            :first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone, :birth, :email,
            :rank, :leadership_position, :additional_leadership_positions, :sub_unit_id, :role,
            :send_reminders,
            :picture, :remove_picture,
            :sms_number, :sms_provider,
            :blast_email, :blast_sms, :sms_message,
            :event_reminder_email, :event_reminder_sms, :signup_deadline_email, :signup_deadline_sms,
            :weekly_newsletter_email, :monthly_newsletter_email,
            phones_attributes: [:id, :kind, :number, :_destroy], scout_ids: [], adult_ids: [], merit_badge_ids: []
            )
    end

    def controller_type
      self.is_a?(ScoutsController) ? :scout : :adult
    end

    # def ar_model
    #   self.is_a?(ScoutsController) ? Scout : Adult
    # end

end
