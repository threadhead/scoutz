class Newsletters < MailerBase

  def weekly(recipient, unit)
    set_time_zone(unit)
    @recipient = recipient
    @events = @unit.events.newsletter_next_week.by_start
    @subject = "Upcoming Events for the Week of #{Time.zone.now.next_week.to_s(:draft_date)}"

    mail to: @recipient.email,
         subject: "#{@unit.email_name} #{@subject}"
  end




  def monthly(recipient, unit)
    set_time_zone(unit)
    @recipient = recipient
    @events = @unit.events.newsletter_next_month.by_start
    @subject = "Upcoming Events for the Month of #{Time.zone.now.next_month.strftime('%B %Y')}"

    mail to: @recipient.email,
         subject: "#{@unit.email_name} #{@subject}",
         template_name: 'weekly'
  end

end
