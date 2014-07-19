require 'rails_helper'

RSpec.describe UserPolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    # @user = FactoryGirl.create(:scout)
    # @record = FactoryGirl.create(:sms_message, sender: @user)
  end


  def self.options
    { policy_class: UserPolicy, policy_resource: FactoryGirl.build_stubbed(:user) }
  end

  [:index?, :show?, :new?, :edit?, :destroy?, :create?, :update?].each do |action|
    permissions action do
      it_behaves_like 'no access'
    end
  end

end
