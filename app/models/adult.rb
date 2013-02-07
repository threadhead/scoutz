class Adult < User
  # finds associated sub_units (dens, patrols, etc.) through their associated scouts
  def sub_units(organization=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:organizations).where(organizations: {id: organization}) if organization
    SubUnit.order('"sub_units"."name" ASC').uniq.joins(:scouts).where(users: {id: scout_ids.all})
  end

  def organization_scouts(organization)
    self.scouts.joins(:organizations).where(organizations: {id: organization})
  end
end
