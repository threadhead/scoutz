module EmailEventSignupsHelper
  def td_email
    {style: "width: 100px; vertical-align: top;"}
  end

  def email_signup_link(options={})
    link_to email_signup_text(options),
            event_email_event_signups_url(options[:event],
                                        {
                                          scouts_attending: options[:scouts],
                                          adults_attending: options[:adults],
                                          siblings_attending: options[:siblings],
                                          scout_id: options[:scout].id,
                                          user_token: options[:recipient_user].signup_token,
                                          event_token: options[:event].signup_token
                                          }
                                        )

  end

  def email_signup_text(options={})
    return options[:body] if options[:body]
    "#{options[:adults]} AD / #{options[:siblings]} sib"
  end

  def email_location(event)
    sanitize(event.location_name) + add_break(event.location_name) +
    sanitize(event.location_address1) + add_break(event.location_address1) +
    sanitize(event.location_address2) + add_break(event.location_address2) +
    sanitize(city_state_zip(event)) + add_break(city_state_zip(event)) +
    (link_to(truncate(event.location_map_url), event.location_map_url, target: '_blank') unless event.location_map_url.blank?)
  end

  def event_name_date(event)
    "#{event.name} on #{event.start_at.to_s(:short_ampm)}"
  end
end
