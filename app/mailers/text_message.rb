class TextMessage < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: "noreply@scoutt.in"

  def event_reminder(event, recipient_email)
    @event = event

    mail to: recipient_email,
         subject: @event.sms_reminder_subject
  end


  def sms_message(recipient_email, sms_message)
    @sms_message = sms_message

    mail to: recipient_email,
         subject: '',
         body: @sms_message.message
  end
end
