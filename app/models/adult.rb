class Adult < User
  # finds associated sub_units (dens, patrols, etc.) through their associated scouts
  def sub_units(unit=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:units).where(units: {id: unit}) if unit
    SubUnit.order('"sub_units"."name" ASC').uniq.joins(:scouts).where(users: {id: scout_ids.all})
  end

  def unit_scouts(unit)
    self.scouts.joins(:units).where(units: {id: unit})
  end
end
