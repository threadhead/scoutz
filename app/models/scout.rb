class Scout < User
  def unit_adults(unit)
    self.adults.joins(:units).where(units: {id: unit})
  end
end
