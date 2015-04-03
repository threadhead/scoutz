require 'rails_helper'

RSpec.describe EventSignupPolicy do
  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @user = FactoryGirl.create(:adult)
    @scout = FactoryGirl.create(:scout)
    @user.scouts << @scout
    @user.units << @unit
    @event = FactoryGirl.create(:event, unit: @unit)
    @record = FactoryGirl.create(:event_signup, user: @user, event: @event)

    @user2 = FactoryGirl.create(:adult)
    @user2.units << @unit
    @scout2 = FactoryGirl.create(:scout)
    @event2 = FactoryGirl.create(:event, unit: @unit)
    @event2.users << @user2
    @record2 = FactoryGirl.create(:event_signup, user: @scout2, event: @event2)
  end

  def self.options
    {
      policy_class: EventSignupPolicy,
      policy_resource: FactoryGirl.build_stubbed(:event_signup, event: FactoryGirl.build_stubbed(:event, unit: FactoryGirl.build_stubbed(:unit)))
    }
  end

  shared_examples 'event owner access' do
    it 'can access if event owner' do
      expect(EventSignupPolicy).to permit(@user2, @record2)
    end
  end

  permissions :index? do
    it_behaves_like 'no access'
  end

  permissions :show? do
    it_behaves_like 'no access'
  end

  permissions :new? do
    it_behaves_like 'user basic access'
  end

  permissions :create? do
    it_behaves_like 'user basic access'
  end

  permissions :edit? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
    it_behaves_like 'event owner access'
  end

  permissions :update? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
    it_behaves_like 'event owner access'
  end

  permissions :destroy? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
    it_behaves_like 'event owner access'
  end

  permissions :activity_consent_form? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'event owner access'

  end
end
