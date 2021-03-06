class Adult < User

  # associated sub_units (dens, patrols, etc.) through their associated scouts, optionally restricted by unit
  def sub_units(unit=nil)
    scout_ids = self.scouts.select('"users"."id"')
    scout_ids = scout_ids.joins(:units).where(units: { id: unit }) if unit
    SubUnit.order('"sub_units"."name" ASC').uniq.joins(:scouts).where(users: { id: scout_ids.to_a })
  end

  # associated scouts in a unit
  def unit_scouts(unit)
    self.scouts.joins(:units).where(units: { id: unit.id })
  end

  # this should never be called, but just in case it is, return the adult
  def unit_adults(_unit)
    Adult.where(id: self.id)
  end


  # from an adult, find all scouts, and other adults related through those scouts
  def unit_family(unit)
    scout_ids = unit_scouts(unit).pluck(:id)
    adult_ids = Adult.joins(:scouts).where(user_relationships: { scout_id: scout_ids })
                .joins(:units).where(units: { id: unit.id })
                .pluck(:id)
    user_ids = (adult_ids + scout_ids) << self.id
    User.where(id: user_ids)
  end



  def handle_relations_update(unit, update)
    # We need the ability to update adult/scout relationships using the standard controller methods

    # Unfortunately, when an adult is edited it will show the names of related scouts that exist for
    #  the unit the adult is being edited under. The retuned "scout_ids" will not contain scouts from
    #  other units, and thus they will be removed from the relationship. BAD!

    # This method will calculate the correct differential necessary for proper updating of the Adult
    # example: all = ['1', '2', '3'], sub_unit = ['1'], update = ['1', '4']
    # result: ['1', '2', '3', '4']

    # example: all = ['1', '2', '3'], sub_unit = ['1'], update = ['4']
    # result: ['2', '3', '4']

    return nil unless update.is_a?(Array)
    all = scouts.pluck(:id).map(&:to_s)
    sub_unit = unit_scouts(unit).pluck(:id).map(&:to_s)
    update_clean = update.reject(&:empty?)
    # ap all
    # ap sub_unit
    # ap update
    # the differential
    (all - (sub_unit - update_clean) + (update_clean - sub_unit)).uniq
  end


  def self.meta_search(unit_scope: nil, keywords:)
    meta_users = unit_scope.nil? ? Adult.all : unit_scope.adults
    meta_users.pg_meta_search(keywords)
  end


  def meta_search_json(unit_scope:)
    { resource: 'adult',
      initials: initials,
      id: id,
      name: name,
      desc: unit_positions.unit(unit_scope.id).try(:leadership) || '&nbsp;',
      url: Rails.application.routes.url_helpers.unit_adult_path(unit_scope, id)
    }
  end


end
