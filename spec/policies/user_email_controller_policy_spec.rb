require 'rails_helper'

RSpec.describe UserEmailControllerPolicy do
  before(:all) do
    # create @user/@record for the 'can access thier own' shared example
    @user = FactoryGirl.create(:scout)
    @record = @user
  end

  def self.options
    { user: :adult, policy_class: UserEmailControllerPolicy, policy_resource: FactoryGirl.build_stubbed(:scout) }
  end


  permissions :update? do
    it_behaves_like 'adult admin access'
    it_behaves_like 'can access thier own'
  end

  describe 'my scouts permissions' do
    before do
      @unit2 = FactoryGirl.create(:unit)
      @adult2 = FactoryGirl.create(:adult, role: 'basic')
      @adult2.units << @unit2
      @scout2 = FactoryGirl.create(:scout)
      @scout2.units << @unit2
    end

    context 'update?' do
      it 'allows parents(adults) to edit scout email' do
        @adult2.scouts << @scout2
        expect(UserEmailControllerPolicy.new(@adult2, @scout2, @unit2).update?).to be(true)
      end

      it 'forbids non-parents from editing scout email' do
        expect(UserEmailControllerPolicy.new(@adult2, @scout2, @unit2).update?).to be(false)
      end
    end

  end
end
