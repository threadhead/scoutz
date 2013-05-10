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
    "#{sanitize_br(event.location_name)}#{sanitize_br(event.location_address1)}#{sanitize_br(event.location_address2)}#{sanitize_br(city_state_zip(event))}#{location_link(event)}"
  end

  def event_name_date(event)
    "#{event.name} on #{event.start_at.to_s(:short_ampm)}"
  end
end
