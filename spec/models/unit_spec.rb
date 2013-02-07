require 'spec_helper'

describe Unit do
  it { should have_and_belong_to_many(:users) }
  it { should have_many(:sub_units) }
  it { should have_many(:events) }

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

  describe '.name' do
    before { @organization = FactoryGirl.build(:organization) }
    subject { @organization }

    it { subject.name.should eq('Cub Scout Pack 134') }
  end

  describe '.name_short' do
    before { @organization = FactoryGirl.build(:organization) }
    subject { @organization }

    it { subject.name_short.should eq('CS Pack 134') }
  end

  describe '.event_kinds' do
    it 'Cub Scout events' do
      organization = FactoryGirl.build(:organization, unit_type: 'Cub Scouts')
      organization.event_kinds.should eq(['Pack Event', 'Den Event', 'Leader Event'])
    end

    it 'Cub Scout events' do
      organization = FactoryGirl.build(:organization, unit_type: 'Boy Scouts')
      organization.event_kinds.should eq(['Troop Event', 'Patrol Event', 'Leader Event'])
    end
  end

  describe '.sub_unit_type' do
    it 'returns Troop for Boy Scouts' do
      organization = FactoryGirl.build(:organization, unit_type: 'Boy Scouts')
      organization.sub_unit_name.should eq('Patrol')
    end

    it 'returns Pack for Cub Scouts' do
      organization = FactoryGirl.build(:organization, unit_type: 'Cub Scouts')
      organization.sub_unit_name.should eq('Den')
    end
  end

  describe 'Organiztion.unit_types' do
    it 'returns all unit types' do
      Organization.unit_types.should eq(['Cub Scouts', 'Boy Scouts', 'Venturing Crew', 'Girl Scouts', 'Order of the Arrow'])
    end
  end

end
