module EventsHelper
  def city_state_zip(event)
    "#{event.location_city}#{event.location_city.blank? ? '' : ', '}#{event.location_city} #{event.location_zip_code}".strip
  end

  def location_show(event)
    sanitize(event.location_name) + add_break(event.location_name) +
    sanitize(event.location_address1) + add_break(event.location_address1) +
    sanitize(event.location_address2) + add_break(event.location_address2) +
    sanitize(city_state_zip(event)) + add_break(city_state_zip(event)) +
    link_to(event.location_map_url, event.location_map_url, target: '_blank') unless event.location_map_url.blank?
  end

  def add_break(str)
    str.blank? ? '' : '<br/>'.html_safe
  end
end
