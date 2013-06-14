require 'spec_helper'

describe Unit do
  # it { should have_and_belong_to_many(:users) }
  it { should have_many(:sub_units) }
  it { should have_many(:events) }

  it { should validate_presence_of(:unit_type) }
  it { should validate_presence_of(:unit_number) }
  it { should validate_presence_of(:time_zone) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }


  describe 'The units-users relationships' do
  	it "units can have many users" do
  		unit = FactoryGirl.create(:unit)
  		user1 = FactoryGirl.build(:user)
  		user2 = FactoryGirl.build(:user)
  		unit.users << [user1, user2]
  		unit.users.count.should eq(2)
  		unit.users.first.id.should eq(user1.id)
  	end

  	it "users can have many units" do
  		user = FactoryGirl.create(:user)
  		unit1 = FactoryGirl.build(:unit)
  		unit2 = FactoryGirl.build(:unit)
  		user.units << [unit1, unit2]
  		user.units.count.should eq(2)
  		user.units.first.id.should eq(unit1.id)
  	end
  end

  describe '.name' do
    before { @unit = FactoryGirl.build(:unit) }
    subject { @unit }

    it { subject.name.should eq('Cub Scout Pack 134') }
  end

  describe '.name_short' do
    before { @unit = FactoryGirl.build(:unit) }
    subject { @unit }

    it { subject.name_short.should eq('CS Pack 134') }
  end

  describe '.event_kinds' do
    it 'Cub Scout events' do
      unit = FactoryGirl.build(:unit, unit_type: 'Cub Scouts')
      unit.event_kinds.should eq(['Pack Event', 'Den Event', 'Leader Event'])
    end

    it 'Cub Scout events' do
      unit = FactoryGirl.build(:unit, unit_type: 'Boy Scouts')
      unit.event_kinds.should eq(['Troop Event', 'Patrol Event', 'Leader Event'])
    end
  end

  describe '.sub_unit_type' do
    it 'returns Troop for Boy Scouts' do
      unit = FactoryGirl.build(:unit, unit_type: 'Boy Scouts')
      unit.sub_unit_name.should eq('Patrol')
    end

    it 'returns Pack for Cub Scouts' do
      unit = FactoryGirl.build(:unit, unit_type: 'Cub Scouts')
      unit.sub_unit_name.should eq('Den')
    end
  end

  describe 'Unit.unit_types' do
    it 'returns all unit types' do
      Unit.unit_types.should eq(['Cub Scouts', 'Boy Scouts', 'Venturing Crew', 'Girl Scouts', 'Order of the Arrow'])
    end
  end

end
