require 'rails_helper'

RSpec.describe Unit do
  # it { should have_and_belong_to_many(:users) }
  it { is_expected.to have_many(:sub_units) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:email_messages) }
  it { is_expected.to have_many(:sms_messages) }
  it { is_expected.to have_many(:health_forms) }

  it { is_expected.to validate_presence_of(:unit_type) }
  it { is_expected.to validate_presence_of(:unit_number) }
  it { is_expected.to validate_presence_of(:time_zone) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  # it { is_expected.to validate_uniqueness_of(:sl_uid).allow_nil }

  let(:unit) { FactoryGirl.build(:unit) }

  describe 'validations' do
    describe 'consent_form_url' do
      it 'required when use_consent_form = 2' do
        unit.attach_consent_form = true
        unit.use_consent_form = 2
        unit.consent_form_url = nil
        expect(unit).not_to be_valid
        expect(unit.errors).to include(:consent_form_url)
      end

      it 'not required when attach_consent_form is false' do
        unit.attach_consent_form = false
        unit.use_consent_form = 2
        unit.consent_form_url = nil
        expect(unit).to be_valid
        expect(unit.errors).not_to include(:consent_form_url)
      end
    end

    describe 'consent_forml' do
      it 'required when use_consent_form = 3' do
        unit.attach_consent_form = true
        unit.use_consent_form = 3
        # unit.consent_form = nil
        expect(unit).not_to be_valid
        expect(unit.errors).to include(:consent_form)
      end

      it 'not required if attach_consent_form is false' do
        unit.attach_consent_form = false
        unit.use_consent_form = 3
        expect(unit).to be_valid
        expect(unit.errors).not_to include(:consent_form)
      end
    end
  end


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

  specify { expect(unit.name).to eq('Cub Scout Pack 134') }
  specify { expect(unit.name_short).to eq('CS Pack 134') }


  describe '.event_kinds' do
    it 'Cub Scout events' do
      unit.unit_type = 'Cub Scouts'
      expect(unit.event_kinds).to eq(['Pack Event', 'Den Event', 'Leader Event'])
    end

    it 'Cub Scout events' do
      unit.unit_type = 'Boy Scouts'
      expect(unit.event_kinds).to eq(['Troop Event', 'Patrol Event', 'Leader Event'])
    end
  end

  describe '.sub_unit_type' do
    it 'returns Troop for Boy Scouts' do
      unit.unit_type = 'Boy Scouts'
      expect(unit.sub_unit_name).to eq('Patrol')
    end

    it 'returns Pack for Cub Scouts' do
      unit.unit_type = 'Cub Scouts'
      expect(unit.sub_unit_name).to eq('Den')
    end
  end

  specify { expect(Unit.unit_types).to eq(['Cub Scouts', 'Boy Scouts', 'Venturing Crew', 'Girl Scouts', 'Order of the Arrow']) }

end
