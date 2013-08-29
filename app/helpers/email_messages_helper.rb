module EmailMessagesHelper
  def sub_unit_emails(sub_unit)
    sub_unit.users_with_emails.map(&:name_email).join(', ')
  end

  def recipient_display(email_message)
    case email_message.send_to_option
    when 1
      "#{email_message.send_to} "
    when 2
      email_message.sub_units.map(&:name).join(', ')
    when 3
      msg = ''
      msg += email_message.send_to
      msg += '<br/>'
      msg += email_message.recipients.map(&:name_email).join('<br/>')
      msg.html_safe
    end
  end
end
