require 'spec_helper'

RSpec.describe DashboardPolicy do
  permissions :index? do
    permission_granted_role_level_and_up(role_level: :basic, policy_class: DashboardPolicy)
    permission_denied_below_role_level(role_level: :inactive, policy_class: DashboardPolicy)
  end
end
