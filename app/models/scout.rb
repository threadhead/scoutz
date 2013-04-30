class Scout < User
  has_many :event_signups, dependent: :destroy

  def unit_adults(unit)
    self.adults.joins(:units).where(units: {id: unit})
  end

  def has_adult?(user)
    self.adults.where(id: user).exists?
  end

  def signed_up_for_event?(event)
    EventSignup.where(scout_id: self.id, event_id: event.id).exists?
  end

  def event_signup_up(event)
    EventSignup.where(scout_id: self.id, event_id: event.id).first
  end
end
