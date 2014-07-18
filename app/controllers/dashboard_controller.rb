class DashboardController < ApplicationController
  before_action :auth_and_time_zone
  # after_action :verify_authorized
  # authorize_resource

  def index
    redirect_to unit_events_url(@unit)
    # policy for both dashboard_calendar and dashboard_list
    # authorize Dashboard
    # authorize! :dashboard, :index
  end
end
