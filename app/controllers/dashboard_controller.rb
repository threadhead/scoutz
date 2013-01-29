class DashboardController < ApplicationController
  before_filter :auth_and_time_zone
  # authorize_resource

  def index
    authorize! :dashboard, :index
    event_finders
    # @limit = params[:limit] ? params[:limit].to_i : 5
    # @organization = Organization.find(params[:organization_id]) if params[:organization_id]
  end
end
