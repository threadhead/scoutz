require 'rails_helper'

RSpec.describe EventPolicy do
  before(:all) do
    @user = FactoryGirl.create(:scout)
    @record = FactoryGirl.create(:event)
    @record.users << @user
  end

  def self.options
    { policy_class: EventPolicy, policy_resource: FactoryGirl.build_stubbed(:event) }
  end

  permissions :index? do
    it_behaves_like 'user basic access'
  end

  permissions :show? do
    it_behaves_like 'user basic access'
  end

  permissions :calendar? do
    it_behaves_like 'user basic access'
  end

  permissions :new? do
    it_behaves_like 'user leader access'
  end

  permissions :edit? do
    it_behaves_like 'user leader access'
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
    it_behaves_like 'user leader access'
    it_behaves_like 'can access thier own'
  end

  permissions :email_attendees? do
    it_behaves_like 'user leader access'
    it_behaves_like 'can access thier own'
  end

  permissions :sms_attendees? do
    it_behaves_like 'user leader access'
    it_behaves_like 'can access thier own'
  end

  permissions :add_signups? do
    it_behaves_like 'can access thier own'
    it_behaves_like 'adult leader access'
  end

end
