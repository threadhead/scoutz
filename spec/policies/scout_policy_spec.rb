require 'spec_helper'

RSpec.describe ScoutPolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    @user = FactoryGirl.create(:scout)
    @record = @user
  end

  def self.options
    { user: :adult, policy_class: ScoutPolicy, policy_resource: FactoryGirl.build_stubbed(:scout) }
  end

  permissions :index? do
    it_behaves_like 'user basic access'
  end

  permissions :show? do
    it_behaves_like 'user basic access'
  end

  permissions :new? do
    it_behaves_like 'user leader access'
  end

  permissions :edit? do
    it_behaves_like 'user leader access'
    permission_granted_role_level_up(options.merge ({ user: :scout, role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :basic }) )

    it_behaves_like 'can access thier own'
  end

  permissions :destroy? do
    it_behaves_like 'adult admin access'
  end

  permissions :create? do
    it_behaves_like 'user leader access'
  end

  permissions :update? do
    it_behaves_like 'user leader access'
    permission_granted_role_level_up(options.merge ({ user: :scout, role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :basic }) )

    it_behaves_like 'can access thier own'
  end
end
