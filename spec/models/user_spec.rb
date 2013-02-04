require 'spec_helper'

describe User do
	it { should have_many(:phones) }
	it { should have_many(:notifiers) }
	it { should have_many(:adults) }
	it { should have_many(:scouts) }
	it { should have_many(:adult_scout_relationships) }
	it { should have_many(:scout_adult_relationships) }
	it { should have_and_belong_to_many(:organizations) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }


  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it 'should have an authentication token' do
  	FactoryGirl.create(:user).authentication_token.empty?.should be_false
  end

  describe 'The adult-scout relationships' do
  	it "adult can have many scouts" do
  		adult = FactoryGirl.create(:user)
  		scout1 = FactoryGirl.build(:user)
  		scout2 = FactoryGirl.build(:user)
  		adult.scouts << [scout1, scout2]
  		adult.scouts.count.should eq(2)
  		adult.scouts.first.id.should eq(scout1.id)
  	end

  	it "scouts can have many adults" do
  		scout = FactoryGirl.create(:user)
  		adult1 = FactoryGirl.build(:user)
  		adult2 = FactoryGirl.build(:user)
  		scout.adults << [adult1, adult2]
  		scout.adults.count.should eq(2)
  		scout.adults.first.id.should eq(adult1.id)
  	end
  end

end
