class EventMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  # def reminder(event_id, recipients, recipient_user_id=nil)
  def reminder(event, recipients, recipient_user)
    # @event = Event.find(event_id)
    # @recipient_user = User.find(recipient_user_id) if recipient_user_id
    @event = event
    @recipient_user = recipient_user

    mail from: "noreply@scoutt.in",
         to: recipients,
         subject: @event.email_reminder_subject

  end
end
