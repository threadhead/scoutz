require 'spec_helper'

describe Organization do
  it { should have_and_belong_to_many(:users) }

  it { should validate_presence_of(:unit_type) }
  it { should validate_presence_of(:unit_number) }
  it { should validate_presence_of(:time_zone) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }


  describe 'The organizations-users relationships' do
  	it "organizations can have many users" do
  		organization = FactoryGirl.create(:organization)
  		user1 = FactoryGirl.build(:user)
  		user2 = FactoryGirl.build(:user)
  		organization.users << [user1, user2]
  		organization.users.count.should eq(2)
  		organization.users.first.id.should eq(user1.id)
  	end

  	it "users can have many organizations" do
  		user = FactoryGirl.create(:user)
  		organization1 = FactoryGirl.build(:organization)
  		organization2 = FactoryGirl.build(:organization)
  		user.organizations << [organization1, organization2]
  		user.organizations.count.should eq(2)
  		user.organizations.first.id.should eq(organization1.id)
  	end
  end

end
