require 'rails_helper'

RSpec.describe Scout do
  before(:all) { adult_2units_2scout_3subunits }

  specify { expect(FactoryGirl.build(:scout)).to be_valid }
  specify { expect(FactoryGirl.build(:scout).type).to eq('Scout') }

  specify { expect(FactoryGirl.build(:scout).scout?).to eq(true) }
  specify { expect(FactoryGirl.build(:scout).adult?).to eq(false) }

  describe '#unit_family(unit)' do
    it 'should find the scout with all their adults in a unit' do
      unit_family = @scout1.unit_family(@unit1)
      expect(unit_family).to include(@adult)
      expect(unit_family).to include(@scout1)

      expect(unit_family).not_to include(@adult2)
      expect(unit_family).not_to include(@adult3)
      expect(unit_family).not_to include(@scout2)
      expect(unit_family).not_to include(@scout3)
    end

    it 'should find the scout with all their related adults in antoher unit' do
      unit_family = @scout2.unit_family(@unit2)
      expect(unit_family).to include(@adult)
      expect(unit_family).to include(@scout2)

      expect(unit_family).not_to include(@adult2)
      expect(unit_family).not_to include(@adult3)
      expect(unit_family).not_to include(@scout1)
      expect(unit_family).not_to include(@scout3)
    end

    it 'if only an scout, then it just returns that scout' do
      unit_family = @scout3.unit_family(@unit1)
      expect(unit_family).to include(@scout3)

      expect(unit_family).not_to include(@scout1)
      expect(unit_family).not_to include(@scout2)
      expect(unit_family).not_to include(@adult)
      expect(unit_family).not_to include(@adult2)
      expect(unit_family).not_to include(@adult3)
    end
  end

end
