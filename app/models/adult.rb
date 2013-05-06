class Adult < User
  # associated sub_units (dens, patrols, etc.) through their associated scouts, optionally restricted by unit
  def sub_units(unit=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:units).where(units: {id: unit}) if unit
    SubUnit.order('"sub_units"."name" ASC').uniq.joins(:scouts).where(users: {id: scout_ids.load})
  end

  # associated scouts in a unit
  def unit_scouts(unit)
    self.scouts.joins(:units).where(units: {id: unit})
  end
end
