require 'spec_helper'

describe Adult do
  before(:all) { adult_2units_2scout_3subunits }

  it 'should be valid' do
    FactoryGirl.build(:adult).should be_valid
  end

  it 'has type: \'Adult\'' do
    FactoryGirl.build(:adult).type.should eq('Adult')
  end

  context '.sub_units' do
    it 'returns sub_units through associated scouts' do
      @adult.sub_units.should include(@sub_unit1)
      @adult.sub_units.should include(@sub_unit2)
      @adult.sub_units.should_not include(@sub_unit3)
    end

    it 'returns sub_units restricted by unit' do
      @adult.sub_units(@unit1).should include(@sub_unit1)
      @adult.sub_units(@unit1).should_not include(@sub_unit2)
      @adult.sub_units(@unit1).should_not include(@sub_unit3)

      @adult.sub_units(@unit2).should include(@sub_unit2)
      @adult.sub_units(@unit2).should_not include(@sub_unit1)
      @adult.sub_units(@unit2).should_not include(@sub_unit3)
    end
  end

  context '.unit_scouts' do
    it 'returns associated scouts in a unit' do
      @adult.unit_scouts(@unit1).should include(@scout1)
      @adult.unit_scouts(@unit1).should_not include(@scout2)

      @adult.unit_scouts(@unit2).should include(@scout2)
      @adult.unit_scouts(@unit2).should_not include(@scout1)
    end
  end
end
