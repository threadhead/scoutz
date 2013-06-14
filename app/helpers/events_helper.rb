module EventsHelper
  def city_state_zip(event)
    "#{event.location_city}#{event.location_city.blank? ? '' : ', '}#{event.location_state} #{event.location_zip_code}".strip
  end

  def event_list_name(event)
    "#{event.start_at.to_s(:short_ampm)} - #{event.name} (#{event_kind_details(event)})"
  end

  def event_kind_details(event)
    if event.sub_unit_kind?
      event_kind_sub_units(event)
    else
      event.kind
    end
  end

  def event_kind_sub_units(event)
    event.sub_units.map(&:name).join(', ')
  end


  def location_show(event)
    "#{sanitize_br(event.location_name)}#{sanitize_br(event.location_address1)}#{sanitize_br(event.location_address2)}#{sanitize_br(city_state_zip(event))}#{location_link(event)}".html_safe
  end

  def location_link(event)
    link_to(truncate(event.location_map_url), event.location_map_url, target: '_blank') unless event.location_map_url.blank?
  end

  def sanitize_br(str)
    "#{sanitize(str)}#{add_break(str)}" if str
  end
  def add_break(str)
    str.blank? ? '' : '<br/>'.html_safe
  end

  def location_map_url_iframe(event)
    event.location_map_url =~ /maps.google.com/ ? event.location_map_url + '&amp;output=embed' : event.location_map_url
  end

end
