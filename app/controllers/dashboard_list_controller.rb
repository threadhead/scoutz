class DashboardListController < DashboardController
  def index
    super
    @limit = (params[:limit] || 5).to_i
    # @units = current_user.units
  end
end
