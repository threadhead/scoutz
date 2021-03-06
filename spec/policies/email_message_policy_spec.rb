require 'rails_helper'

RSpec.describe EmailMessagePolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    @user = FactoryGirl.create(:scout)
    @record = FactoryGirl.create(:email_message, sender: @user)
  end


  def self.options
    { policy_class: EmailMessagePolicy, policy_resource: FactoryGirl.build_stubbed(:email_message, sender: FactoryGirl.build_stubbed(:user)) }
  end

  permissions :index? do
    # everyone!
    permission_granted_role_level_up(options.merge(role_level: :inactive))
  end

  permissions :show? do
    permission_granted_role_level_up(options.merge(role_level: :basic))
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

  permissions :show_recipients? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

end
