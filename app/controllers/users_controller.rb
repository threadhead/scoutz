class UsersController < ApplicationController
  # etag { current_user.try :id }

  before_action :auth_and_time_zone
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :send_welcome_reset_password]
  after_action :verify_authorized

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def new(ar_model)
    @user = ar_model.new
    authorize @user
    # @user.unit_positions.create(unit_id: @unit.id)
  end

  def send_welcome_reset_password
    authorize @user
    @user.confirm!

    token = @user.send(:set_reset_password_token)
    @user.reset_password_sent_at = 72.hours.from_now - Devise.reset_password_within
    @user.encrypted_password = nil
    @user.save(validate: false)
    AdminMailer.delay.send_existing_user_welcome(user_id: @user.id, token: token)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      @searching = false
    end

    def remove_new_phone_attribute
      params[controller_type][:phones_attributes].delete('new_phone')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(controller_type).permit(
            :first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone, :birth, :email,
            :rank, :sub_unit_id, :role,
            :send_reminders,
            :picture, :remove_picture,
            :sms_number, :sms_provider,
            :blast_email, :blast_sms, :sms_message,
            :event_reminder_email, :event_reminder_sms, :signup_deadline_email, :signup_deadline_sms,
            :weekly_newsletter_email, :monthly_newsletter_email,
            phones_attributes: [:id, :kind, :number, :_destroy], scout_ids: [], adult_ids: [],
            counselors_attributes: [:id, :merit_badge_id, :unit_id, :_destroy],
            unit_positions_attributes: [:id, :leadership, :additional, :unit_id],
            health_forms_attributes: [:id, :unit_id, :part_a_date, :part_b_date, :part_c_date, :florida_sea_base_date, :philmont_date, :northern_tier_date, :summit_tier_date]
            )
    end

    def controller_type
      self.is_a?(ScoutsController) ? :scout : :adult
    end

    # def ar_model
    #   self.is_a?(ScoutsController) ? Scout : Adult
    # end

end
