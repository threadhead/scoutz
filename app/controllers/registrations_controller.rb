class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  layout 'modals'

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  protected

    def after_sign_up_path_for(_resource)
      sign_up_user_url
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
    end
end
