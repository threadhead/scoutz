require 'spec_helper'

RSpec.describe SubUnit do
  it { should belong_to(:unit) }
  it { should have_and_belong_to_many(:events) }
  it { should have_many(:scouts) }
  it { should have_many(:adults) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:unit_id) }

  # it 'validates uniqueness of name' do
  #   FactoryGirl.create(:sub_unit)
  #   should validate_uniqueness_of(:name).case_insensitive.scoped_to(:unit_id)
  # end

  let(:sub_unit) { FactoryGirl.create(:sub_unit) }

  it "should be valid" do
    FactoryGirl.build(:sub_unit).should be_valid
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
