class WelcomeController < Devise::PasswordsController
  def update
    @params = params
    super
  end

  def edit
    @params = params
    super
  end
end
