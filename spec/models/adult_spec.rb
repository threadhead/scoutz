require 'spec_helper'

describe Adult do
  it 'should be valid' do
    FactoryGirl.build(:adult).should be_valid
  end

  it 'has type: \'Adult\'' do
    FactoryGirl.build(:adult).type.should eq('Adult')
  end

  context '.sub_units' do
    before(:all) do
      @adult = FactoryGirl.create(:adult)
      @unit1 = FactoryGirl.create(:unit)
      @unit2 = FactoryGirl.create(:unit, unit_type: 'Boy Scouts', unit_number: '603')
      @adult.units << @unit1
      @adult.units << @unit2
      @scout1 = FactoryGirl.create(:scout)
      @scout2 = FactoryGirl.create(:scout)
      @adult.scouts << @scout1
      @adult.scouts << @scout2
      @scout1.units << @unit1
      @scout2.units << @unit2
      @sub_unit1 = FactoryGirl.create(:cub_scout_sub_unit, unit: @unit1)
      @sub_unit1.scouts << @scout1
      @sub_unit2 = FactoryGirl.create(:boy_scout_sub_unit, unit: @unit2)
      @sub_unit2.scouts << @scout2
      @sub_unit3 = FactoryGirl.create(:cub_scout_sub_unit, unit: @unit1)
    end

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
end
