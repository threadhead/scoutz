require 'spec_helper'

RSpec.describe ScoutPolicy do
  def self.options
    { user: :adult, policy_class: ScoutPolicy, policy_resource: FactoryGirl.build_stubbed(:scout) }
  end

  permissions :index? do
    permission_granted_role_level_up( options.merge ({ role_level: :basic }) )
    permission_denied_role_level_down(options.merge ({ role_level: :inactive }) )
  end

  permissions :show? do
    permission_granted_role_level_up(options.merge ({ role_level: :basic }) )
    permission_denied_role_level_down(options.merge ({ role_level: :inactive }) )
  end

  permissions :new? do
    permission_granted_role_level_up(options.merge ({ role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ role_level: :basic }) )
  end

  permissions :edit? do
    permission_granted_role_level_up(options.merge ({ role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ role_level: :basic }) )
    permission_granted_role_level_up(options.merge ({ user: :scout, role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :basic }) )

    it 'users can edit themselves' do
      user = FactoryGirl.build_stubbed(:scout)
      expect(ScoutPolicy).to permit(user, user)
    end
  end

  permissions :destroy? do
    permission_granted_role_level_up(options.merge ({ role_level: :admin }) )
    permission_denied_role_level_down(options.merge ({ role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :admin }) )
  end

  permissions :create? do
    permission_granted_role_level_up(options.merge ({ role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ role_level: :basic }) )
  end

  permissions :update? do
    permission_granted_role_level_up(options.merge ({ role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ role_level: :basic }) )
    permission_granted_role_level_up(options.merge ({ user: :scout, role_level: :leader }) )
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :basic }) )

    it 'users can update themselves' do
      user = FactoryGirl.build_stubbed(:scout)
      expect(ScoutPolicy).to permit(user, user)
    end
  end
end
