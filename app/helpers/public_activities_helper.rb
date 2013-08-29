module PublicActivitiesHelper
  def activity_scout(activity)
    Scout.find(activity.parameters[:scout_id]) if activity.parameters.has_key?(:scout_id)
  end

  def activity_event(activity)
    Event.find(activity.parameters[:event_id]) if activity.parameters.has_key?(:event_id)
  end

  def activity_scout_link(activity)
    scout = activity_scout(activity)
    if scout
      link_to scout.f_name_l_initial, unit_scout_path(activity.unit_id, scout)
    end
  end

  def activity_event_link(activity)
    event = activity_event(activity)
    if event
      link_to event.name, unit_event_path(activity.unit_id, event)
    end
  end

end
