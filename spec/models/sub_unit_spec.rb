require 'rails_helper'

RSpec.describe SubUnit do
  it { should belong_to(:unit) }
  it { should have_and_belong_to_many(:events) }
  it { should have_many(:scouts) }
  it { should have_many(:adults) }

  it { should validate_presence_of(:name) }

  describe 'validations' do
    subject { FactoryGirl.create(:sub_unit) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:unit_id) }
  end

  # it 'validates uniqueness of name' do
  #   FactoryGirl.create(:sub_unit)
  #   should validate_uniqueness_of(:name).case_insensitive.scoped_to(:unit_id)
  # end

  let(:sub_unit) { FactoryGirl.create(:sub_unit) }

  it "should be valid" do
    FactoryGirl.build(:sub_unit).should be_valid
  end

  describe '.type' do
    it 'returns Patrol for Boy Scouts units' do
      unit = FactoryGirl.create(:unit, unit_type: 'Boy Scouts')
      sub_unit.unit = unit
      expect(sub_unit.type).to eq('Patrol')
    end

    it 'returns Den for Cub Scout units' do
      unit = FactoryGirl.create(:unit)
      sub_unit.unit = unit
      expect(sub_unit.type).to eq('Den')
    end
  end

  context 'finders' do
    before(:all) do
      @sub_unit = FactoryGirl.create(:sub_unit)
      @adult1 = FactoryGirl.create(:adult)
      @scout1 = FactoryGirl.create(:scout, sub_unit: @sub_unit)
      @adult1.scouts << @scout1
      @adult2 = FactoryGirl.create(:adult)
      @scout2 = FactoryGirl.create(:scout, sub_unit: @sub_unit, email: 'abc@gmail.com')
      @adult2.scouts << @scout2
      @adult3 = FactoryGirl.create(:adult)
    end

    describe '.users_with_emails' do
      specify { expect(@sub_unit.users_with_emails).to include(@adult1) }
      specify { expect(@sub_unit.users_with_emails).to include(@adult2) }
      specify { expect(@sub_unit.users_with_emails).to include(@scout2) }
      specify { expect(@sub_unit.users_with_emails).not_to include(@scout1) }
    end

    describe '.adults' do
      describe 'finds adults through scouts in the unit' do
        specify { expect(@sub_unit.adults).to include(@adult1) }
        specify { expect(@sub_unit.adults).to include(@adult2) }
        specify { expect(@sub_unit.adults).not_to include(@adult3) }
      end

      describe 'finds no scouts' do
        specify { expect(@sub_unit.adults).not_to include(@scout1) }
        specify { expect(@sub_unit.adults).not_to include(@scout2) }
      end
    end
  end
end
