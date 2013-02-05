class SessionsController < Devise::SessionsController
  helper :all

  def new; super; end
  def create; super; end
  def destroy; super; end
end
