class DashboardController < ApplicationController
  before_action :auth_and_time_zone
  after_action :verify_authorized
  # authorize_resource

  def index
    # policy for both dashboard_calendar and dashboard_list
    authorize Dashboard
    # authorize! :dashboard, :index
  end
end
