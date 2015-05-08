module EmailEventSignupsHelper
  def td_col_1
    'width: 124px;'
  end

  def td_border
    'vertical-align: top; border-bottom: 1px solid #ddd; padding-top: 3px; padding-bottom: 3px;'
  end

  def flat_button
    'color: #fff; display: inline-block; margin: 0 10px 10px 0; padding: 10px 18px; font-size: 14px; text-decoration: none; border: none;'
  end

  def recipient_signup_users_for_event(recipient, event)
    if recipient.blank?
      []
    elsif recipient.adult?
      recipient.unit_family(event.unit).order(type: :desc)
    else
      [recipient]
    end

    # if recipient && recipient.adult?
    #   recipient.unit_family(event.unit)
    # else
    #   recipient.blank? ? [] : [@recipient]
    # end
  end

  def email_signup_link(options={})
    link_to email_signup_text(options),
            event_email_event_signups_url(options[:event],
                                            {
                                              scouts_attending: options[:scouts],
                                              adults_attending: options[:adults],
                                              siblings_attending: options[:siblings],
                                              user_id: options[:scout].id,
                                              user_token: options[:recipient].signup_token,
                                              event_token: options[:event].signup_token
                                            }
                                         )
  end

  def email_signup_text(options={})
    return options[:body] if options[:body]
    "#{options[:adults]} AD / #{options[:siblings]} sib"
  end

  def email_location(event)
    "#{sanitize_br(event.location_name)}#{sanitize_br(event.location_address1)}#{sanitize_br(event.location_address2)}#{sanitize_br(city_state_zip(event))}#{location_link(event)}".html_safe
  end

  def event_name_date(event)
    "#{event.name} on #{event.start_at.to_s(:short_ampm)}"
  end
end
