require 'spec_helper'

RSpec.describe MeritBadgePolicy do
  before(:all) do
    @merit_badge = FactoryGirl.build_stubbed(:merit_badge)
    @record = @merit_badge
  end

  def self.options
    { policy_class: MeritBadgePolicy, policy_resource: FactoryGirl.build_stubbed(:merit_badge) }
  end

  permissions :index? do
    it_behaves_like 'user basic access'
  end

  permissions :show? do
    it_behaves_like 'user basic access'
  end

  permissions :new? do
    it_behaves_like 'no access'
  end

  permissions :edit? do
    it_behaves_like 'user leader access'
  end

  permissions :destroy? do
    it_behaves_like 'no access'
  end

  permissions :create? do
    it_behaves_like 'no access'
  end

  permissions :update? do
    it_behaves_like 'user leader access'
  end
end
