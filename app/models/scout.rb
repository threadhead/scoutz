class Scout < User
  has_many :event_signups

  def unit_adults(unit)
    self.adults.joins(:units).where(units: {id: unit})
  end

  def has_adult?(user)
    self.adults.where(id: user).exists?
  end
end
