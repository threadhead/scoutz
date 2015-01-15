class EventMailer < MailerBase
  def reminder(event, recipient)
    @event = event
    @recipient = recipient
    set_time_zone(@event.unit)

    mail to: @recipient.email,
         subject: @event.email_reminder_subject

  end
end
