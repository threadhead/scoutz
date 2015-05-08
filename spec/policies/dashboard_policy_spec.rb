require 'rails_helper'

RSpec.describe DashboardPolicy do
  def self.options
    { policy_class: DashboardPolicy, policy_resource: Dashboard }
  end

  permissions :index? do
    permission_granted_role_level_up(options.merge(role_level: :basic))
    permission_denied_role_level_down(options.merge(role_level: :inactive))
  end
end
