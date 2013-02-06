class Adult < User
  def sub_units(organization=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:organizations).where(organizations: {id: organization}) if organization
    SubUnit.joins(:scouts).where(users: {id: scout_ids.all} )
  end

  def organization_scouts(organization)
    self.scouts.joins(:organizations).where(organizations: {id: organization})
  end
end
