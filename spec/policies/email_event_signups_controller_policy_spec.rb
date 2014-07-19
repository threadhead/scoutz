require 'rails_helper'

RSpec.describe EmailEventSignupsControllerPolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    # @user = FactoryGirl.create(:scout)
    # @record = FactoryGirl.create(:sms_message, sender: @user)
  end


  def self.options
    { policy_class: EmailEventSignupsControllerPolicy, policy_resource: EmailEventSignupsController }
  end

  [:new?, :edit?].each do |action|
    permissions action do
      it_behaves_like 'no access'
    end
  end

  [:index?, :show?, :destroy?, :create?, :update?].each do |action|
    permissions action do
      permission_granted_role_level_up( options.merge({role_level: :inactive}))
    end
  end

end
