class Scout < User
  has_many :event_signups, dependent: :destroy

  def unit_adults(unit)
    self.adults.joins(:units).where(units: {id: unit})
  end

  # when scouts view other scouts records
  def unit_scouts(unit)
    Scout.where(id: self.id)
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


  def self.meta_search(unit_scope: nil, keywords:)
    meta_users = unit_scope.nil? ? Scout.all : unit_scope.scouts
    meta_users.pg_meta_search(keywords)
  end


  def meta_search_json(unit_scope:)
    { resource: 'scout',
      initials: initials,
      id: id,
      name: name,
      desc: [rank, sub_unit.try(:name)].join(' - ') || '&nbsp;',
      url: Rails.application.routes.url_helpers.unit_scout_path(unit_scope, id)
    }
  end

end
