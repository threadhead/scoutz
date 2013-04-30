module ModelHelpers

  def adult_2units_2scout_3subunits
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
end
