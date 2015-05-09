module ModelHelpers
  def adult_2units_2scout_3subunits
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit, unit_type: 'Boy Scouts', unit_number: '603')

    @adult = FactoryGirl.create(:adult, sms_number: '1111111111', sms_provider: 'T-Mobile', event_reminder_sms: true)
    @adult.unit_positions.create(unit_id: @unit1.id, leadership: 'Cubmaster')
    @adult2 = FactoryGirl.create(:adult, sms_number: '2222222222', sms_provider: 'Verizon', event_reminder_sms: true)
    @adult2.unit_positions.create(unit_id: @unit2.id, leadership: 'Asst Scoutmaster')
    @adult3 = FactoryGirl.create(:adult)
    @adult_related_u1 = FactoryGirl.create(:adult, first_name: 'Related', last_name: 'Adult')

    # add adults to units
    @adult.units << @unit1
    @adult.units << @unit2
    @adult2.units << @unit2
    @adult3.units << @unit1
    @adult_related_u1.units << @unit1

    @scout1 = FactoryGirl.create(:scout, role: :leader)
    @scout1.unit_positions.create(unit_id: @unit1.id, leadership: 'Denner')
    @scout2 = FactoryGirl.create(:scout, email: 'bo@aol.com', sms_number: '3333333333', sms_provider: 'Verizon', event_reminder_sms: true, blast_email: true)
    @scout3 = FactoryGirl.create(:scout, email: 'asdf@aol.com', sms_number: '4444444444', sms_provider: 'Verizon', event_reminder_sms: true)
    @scout_related_u1 = FactoryGirl.create(:scout, email: 'scout_related@aol.com', first_name: 'Related', last_name: 'Scout', blast_email: false)

    # associate scouts with adult
    @adult.scouts << @scout1
    @adult.scouts << @scout2
    @adult_related_u1.scouts << @scout_related_u1
    # add scouts to units
    @scout1.units << @unit1
    @scout3.units << @unit1
    @scout2.units << @unit2
    @scout_related_u1.units << @unit1

    @sub_unit1 = FactoryGirl.create(:cub_scout_sub_unit, unit: @unit1)
    @sub_unit1.scouts << @scout1
    @sub_unit1.scouts << @scout_related_u1
    @sub_unit2 = FactoryGirl.create(:boy_scout_sub_unit, unit: @unit2)
    @sub_unit2.scouts << @scout2
    @sub_unit3 = FactoryGirl.create(:cub_scout_sub_unit, unit: @unit1)
  end

  def unit_meeting_kinds
    [
      'Pack Event',
      'Troop Event',
      'Crew Event',
      'Lodge Event',
      'Troop Meeting',
      'Pack Meeting',
      'Crew Meeting',
      'Camping/Outing',
      'PLC',
      'Lodge Meeting'
    ]
  end
end
