class EventMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  def reminder(event, recipient)
    @event = event
    @recipient = recipient

    mail from: "noreply@scoutt.in",
         to: @recipient.email,
         subject: @event.email_reminder_subject

  end
end
