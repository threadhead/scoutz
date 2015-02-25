require 'rails_helper'

RSpec.describe HealthFormPolicy do
  before(:all) do
    @user = FactoryGirl.build_stubbed(:health_form)
    @record = @user
  end

  def self.options
    { user: :adult, policy_class: HealthFormPolicy, policy_resource: FactoryGirl.build_stubbed(:health_form) }
  end

  permissions :index? do
    # it_behaves_like 'adult admin access'
  end

end
