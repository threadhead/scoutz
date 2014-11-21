module FeatureHelpers

  def sign_in_user(email, password)
    visit new_user_session_path
    within("#new_user") do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
    end
    click_button 'Sign in'
  end

  def create_cub_scout_unit
    @unit = FactoryGirl.create(:unit)
    @sub_unit1 = FactoryGirl.create(:cub_scout_sub_unit, name: 'Den 44')
    @sub_unit2 = FactoryGirl.create(:cub_scout_sub_unit, name: 'Den 55')
    @unit.sub_units << @sub_unit1
    @unit.sub_units << @sub_unit2

    @user = FactoryGirl.create(:adult, first_name: 'Tara', last_name: 'Karl', role: 'admin')
    @user.unit_positions.create(unit_id: @unit.id, leadership: 'Committee Chair')
    @user.units << @unit
    @scout1 = FactoryGirl.create(:scout, sub_unit: @sub_unit1)
    @user.scouts << @scout1
    @scout1.units << @unit
    @scout2 = FactoryGirl.create(:scout, first_name: 'Aydan', last_name: 'Russel', sub_unit: @sub_unit2)
    @user.scouts << @scout2
    @scout2.units << @unit
  end

  def create_boy_scout_unit
    @unit = FactoryGirl.create(:unit, unit_type: 'Boy Scouts')
    @sub_unit1 = FactoryGirl.create(:boy_scout_sub_unit, name: 'Hawks')
    @sub_unit2 = FactoryGirl.create(:boy_scout_sub_unit, name: 'Scorpions')
    @unit.sub_units << @sub_unit1
    @unit.sub_units << @sub_unit2

    @user = FactoryGirl.create(:adult, first_name: 'Denise', last_name: 'Richards', role: 'admin')
    @user.unit_positions.create(unit_id: @unit.id, leadership: 'Committee Chair')
    @user.units << @unit
    @scout1 = FactoryGirl.create(:scout, sub_unit: @sub_unit1)
    @user.scouts << @scout1
    @scout1.units << @unit
    @scout2 = FactoryGirl.create(:scout, first_name: 'Mark', last_name: 'Munroe', sub_unit: @sub_unit2)
    @user.scouts << @scout2
    @scout2.units << @unit
  end

end
