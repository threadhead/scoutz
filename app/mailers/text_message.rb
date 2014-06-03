class TextMessage < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: "noreply@scoutt.in"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.text_message.event_reminder.subject
  #
  def event_reminder(event_id, recipient_email)
    @event = Event.find(event_id)

    mail to: recipient_email,
         subject: @event.sms_reminder_subject
  end

  def email_message(email_message_id, recipient_email)
    @email_message = EmailMessage.find(email_message_id)

    mail to: recipient_email,
         subject: @email_message.sms_subject
  end
end
