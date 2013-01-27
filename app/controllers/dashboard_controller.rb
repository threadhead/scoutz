class DashboardController < ApplicationController
  before_filter :auth_and_time_zone
  # authorize_resource

  def index
    authorize! :dashboard, :index
  end
end
