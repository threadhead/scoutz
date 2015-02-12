class ConfirmationsController < Devise::ConfirmationsController

  def show
    conf_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
    user = User.where(confirmation_token: conf_token).first
    @original_email = user.try(:email)

    super
  end

  protected

    def after_confirmation_path_for(resource_name, resource)
      path = if signed_in?(resource_name)
        signed_in_root_path(resource)
      else
        new_session_path(resource_name)
      end

      UserConfirmationsMailer.after_email_change(resource, @original_email).deliver_later
      path
    end

end
