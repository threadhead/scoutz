require 'spec_helper'

RSpec.describe AdultPolicy do
  def self.options
    { user: :adult, policy_class: AdultPolicy, policy_resource: FactoryGirl.build_stubbed(:adult) }
  end

  permissions :index? do
    permission_granted_role_level_and_up( options.merge ({ role_level: :basic }) )
    permission_denied_below_role_level(options.merge ({ role_level: :inactive }) )
  end

  permissions :show? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :basic }) )
    permission_denied_below_role_level(options.merge ({ role_level: :inactive }) )
  end

  permissions :new? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :leader }) )
    permission_denied_below_role_level(options.merge ({ role_level: :basic }) )
  end

  permissions :edit? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :leader }) )
    permission_denied_below_role_level(options.merge ({ role_level: :basic }) )
    permission_denied_below_role_level(options.merge ({ user: :scout, role_level: :admin }) )
  end

  permissions :destroy? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :admin }) )
    permission_denied_below_role_level(options.merge ({ role_level: :leader }) )
  end

  permissions :create? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :leader }) )
    permission_denied_below_role_level(options.merge ({ role_level: :basic }) )
  end

  permissions :update? do
    permission_granted_role_level_and_up(options.merge ({ role_level: :leader }) )
    permission_denied_below_role_level(options.merge ({ role_level: :basic }) )
  end
end
