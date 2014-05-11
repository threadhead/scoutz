class Adult < User
  # associated sub_units (dens, patrols, etc.) through their associated scouts, optionally restricted by unit
  def sub_units(unit=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:units).where(units: {id: unit}) if unit
    SubUnit.order('"sub_units"."name" ASC').uniq.joins(:scouts).where(users: {id: scout_ids.to_a})
  end

  # associated scouts in a unit
  def unit_scouts(unit)
    self.scouts.joins(:units).where(units: {id: unit})
  end

  def handle_relations_update(unit, update)
    # We need the ability to update adult/scout relationships using the standard controller methods

    # Unfortunately, when an adults is edited it will show the names of related scouts that exist for
    #  the unit the adult is being edited under. The retuned "scout_ids" will not contain scouts from
    #  other units, and thus they will be removed from the relationship BAD!

    # This method will calculate the correct differential necessary for proper updating of the Adult
    # example: all = ['1', '2', '3'], sub_unit = ['1'], update = ['1', '4']
    # result: ['1', '2', '3', '4']

    # example: all = ['1', '2', '3'], sub_unit = ['1'], update = ['4']
    # result: ['2', '3', '4']

    return nil unless update.is_a?(Array)
    all = scouts.pluck(:id).map{|id| id.to_s}
    sub_unit = unit_scouts(unit).pluck(:id).map{|id| id.to_s}
    update_clean = update.reject { |u| u.empty? }
    # ap all
    # ap sub_unit
    # ap update
    # the differential
    ( all - (sub_unit - update_clean) + (update_clean - sub_unit)).uniq
  end
end
