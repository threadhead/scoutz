require 'spec_helper'

RSpec.describe AdultPolicy do
  before(:all) do
    @user = FactoryGirl.build_stubbed(:scout)
    @record = @user
  end

  def self.options
    { user: :adult, policy_class: AdultPolicy, policy_resource: FactoryGirl.build_stubbed(:adult) }
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
    permission_denied_role_level_down(options.merge ({ user: :scout, role_level: :admin }) )
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
    it_behaves_like 'can access thier own'
  end
end
