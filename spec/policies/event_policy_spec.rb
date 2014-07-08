require 'spec_helper'

RSpec.describe EventPolicy do
  before(:all) do
    @user = FactoryGirl.create(:scout)
    @event = FactoryGirl.create(:event)
    @event.users << @user
  end

  shared_examples 'can access thier own' do
    it "users can #{self.parent.name.split('::').last.downcase} their own events" do
      expect(EventPolicy).to permit(@user, @event)
    end
  end

  def self.options
    { policy_class: EventPolicy, policy_resource: FactoryGirl.build_stubbed(:event) }
  end

  permissions :index? do
    permission_granted_role_level_up( options.merge({role_level: :basic}))
    permission_denied_role_level_down( options.merge({role_level: :inactive}))
  end

  permissions :show? do
    permission_granted_role_level_up( options.merge({role_level: :basic}))
    permission_denied_role_level_down( options.merge({role_level: :inactive}))
  end

  permissions :new? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
  end

  permissions :edit? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
    it_behaves_like 'can access thier own'
  end

  permissions :destroy? do
    permission_granted_role_level_up( options.merge({user: :adult, role_level: :admin}))
    permission_denied_role_level_down( options.merge({user: :adult, role_level: :leader}))
    permission_denied_role_level_down( options.merge({user: :scout, role_level: :admin}))
    it_behaves_like 'can access thier own'
  end

  permissions :create? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
  end

  permissions :update? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
    it_behaves_like 'can access thier own'
  end

  permissions :email_attendees? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
    it_behaves_like 'can access thier own'
  end

  permissions :sms_attendees? do
    permission_granted_role_level_up( options.merge({role_level: :leader}))
    permission_denied_role_level_down( options.merge({role_level: :basic}))
    it_behaves_like 'can access thier own'
  end

end
