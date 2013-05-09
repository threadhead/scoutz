class EventMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.reminder.subject
  #
  def reminder(event, recipients, recipient_user=nil)
    @event = event
    @recipient_user = recipient_user

    mail from: "noreply@scoutt.in",
         to: recipients,
         subject: @event.reminder_subject

  end
end
