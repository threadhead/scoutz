class PasswordsController < Devise::PasswordsController

  def new; super; end
  def create; super; end

  def update
    @params = params
    super
  end

  def edit
    @params = params
    super
  end
end
