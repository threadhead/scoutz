class DashboardListController < DashboardController
  def index
    super
    @limit = (params[:limit] || 5).to_i
    @organizations = current_user.organizations
  end
end
