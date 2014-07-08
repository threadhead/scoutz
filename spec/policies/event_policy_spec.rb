require 'spec_helper'

RSpec.describe EventPolicy do
  def self.options
    { policy_class: EventPolicy, policy_resource: FactoryGirl.build_stubbed(:event) }
  end

  permissions :index? do
    permission_granted_role_level_and_up( options.merge({role_level: :basic}))
    permission_denied_below_role_level( options.merge({role_level: :inactive}))
  end

  permissions :show? do
    permission_granted_role_level_and_up( options.merge({role_level: :basic}))
    permission_denied_below_role_level( options.merge({role_level: :inactive}))
  end

  permissions :new? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :edit? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :destroy? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :create? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :update? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :email_attendees? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

  permissions :sms_attendees? do
    permission_granted_role_level_and_up( options.merge({role_level: :leader}))
    permission_denied_below_role_level( options.merge({role_level: :basic}))
  end

end
