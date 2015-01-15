class TextMessage < MailerBase
  add_template_helper(ApplicationHelper)


  def event_reminder(event, recipient_email)
    @event = event
    set_time_zone(@event.unit)

    mail to: recipient_email,
         subject: @event.sms_reminder_subject
  end


  def sms_message(recipient_email, sms_message)
    @sms_message = sms_message
    set_time_zone(@sms_message.unit)

    mail to: recipient_email,
         subject: '',
         body: @sms_message.message
  end
end
