class Scout < User
  def organization_adults(organization)
    self.adults.joins(:organizations).where(organizations: {id: organization})
  end
end
