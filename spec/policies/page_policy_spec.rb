require 'rails_helper'

RSpec.describe PagePolicy do
  def self.options
    { policy_class: PagePolicy, policy_resource: FactoryGirl.build_stubbed(:page) }
  end

  permissions :index? do
    it_behaves_like 'user leader access'
  end

  permissions :show? do
    it_behaves_like 'user basic access'
  end

  permissions :show_admin? do
    it_behaves_like 'user leader access'
  end

  permissions :new? do
    it_behaves_like 'user leader access'
  end

  permissions :edit? do
    it_behaves_like 'user leader access'
  end

  permissions :destroy? do
    it_behaves_like 'user leader access'
  end

  permissions :create? do
    it_behaves_like 'user leader access'
  end

  permissions :update? do
    it_behaves_like 'user leader access'
  end

  permissions :move_higher? do
    it_behaves_like 'user leader access'
  end

  permissions :move_lower? do
    it_behaves_like 'user leader access'
  end
end
