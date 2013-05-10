class EventMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  def reminder(event, recipients, recipient_user=nil)
    @event = event
    @recipient_user = recipient_user

    mail from: "noreply@scoutt.in",
         to: recipients,
         subject: @event.reminder_subject

  end
end
