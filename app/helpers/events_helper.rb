module EventsHelper
  def city_state_zip(event)
    "#{event.location_city}#{event.location_city.blank? ? '' : ', '}#{event.location_city} #{event.location_zip_code}".strip
  end

  def event_list_name(event)
    "#{event.start_at.to_s(:short_ampm)} - #{event.name} (#{event_kind_details(event)})"
  end

  def event_kind_details(event)
    case event.kind
    when 'Den Event', 'Patrol Event'
      event.sub_units.map(&:name).join(',')
    else
      event.kind
    end
  end

  def location_show(event)
    sanitize(event.location_name) + add_break(event.location_name) +
    sanitize(event.location_address1) + add_break(event.location_address1) +
    sanitize(event.location_address2) + add_break(event.location_address2) +
    sanitize(city_state_zip(event)) + add_break(city_state_zip(event)) +
    (link_to(truncate(event.location_map_url), event.location_map_url, target: '_blank') unless event.location_map_url.blank?)
  end

  def add_break(str)
    str.blank? ? '' : '<br/>'.html_safe
  end

  def location_map_url_iframe(event)
    event.location_map_url =~ /maps.google.com/ ? event.location_map_url + '&amp;output=embed' : event.location_map_url
  end
end
