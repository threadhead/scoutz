require 'spec_helper'

RSpec.describe SmsMessagePolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    @user = FactoryGirl.create(:scout)
    @record = FactoryGirl.create(:sms_message, sender: @user)
  end


  def self.options
    { policy_class: SmsMessagePolicy, policy_resource: FactoryGirl.build_stubbed(:sms_message, sender: FactoryGirl.build_stubbed(:user)) }
  end

  permissions :index? do
    # everyone!
    permission_granted_role_level_up( options.merge({role_level: :inactive}))
  end

  permissions :show? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

  permissions :new? do
    it_behaves_like 'user leader access'
  end

  permissions :edit? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

  permissions :destroy? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

  permissions :create? do
    it_behaves_like 'user leader access'
  end

  permissions :update? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

end
