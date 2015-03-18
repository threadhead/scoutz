module PublicActivitiesHelper
  def activity_scout(activity)
    if activity.parameters.has_key?(:scout_id)
      Scout.where(id: activity.parameters[:scout_id]).first
    elsif activity.parameters.has_key?(:user_id)
      User.where(id: activity.parameters[:user_id]).first
    end
  end

  def activity_event(activity)
    Event.where(id: activity.parameters[:event_id]).first if activity.parameters.has_key?(:event_id)
  end

  def activity_scout_link(activity)
    user = activity_scout(activity)
    if user
      unit_user_link(activity.unit_id, user)
    end
  end

  def activity_event_link(activity)
    event = activity_event(activity)
    if event
      link_to event.name, unit_event_path(activity.unit_id, event)
    end
  end

end
