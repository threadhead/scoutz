class RegistrationsController < Devise::RegistrationsController
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

    def after_sign_up_path_for(resource)
      sign_up_user_url
    end

end
