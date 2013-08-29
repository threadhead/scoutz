class DashboardController < ApplicationController
  before_filter :auth_and_time_zone
  # authorize_resource

  def index
    authorize! :dashboard, :index
    # event_finders
    # @limit = params[:limit] ? params[:limit].to_i : 5
    # @unit = Unit.find(params[:unit_id]) if params[:unit_id]
  end
end
