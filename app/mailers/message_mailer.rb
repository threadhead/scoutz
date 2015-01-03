class MessageMailer < MailerBase
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)


  def email_blast_no_events(recipient, email_message)
    @email_message = email_message
    @events = []
    @sender = @email_message.sender
    @recipient = recipient
    set_time_zone(@email_message.unit)

    set_attachments

    mail from: @sender.email,
         to: @recipient.email,
         subject: @email_message.subject_with_unit,
         template_name: 'email_blast'

  end


  def email_blast_with_event(recipient, email_message)
    @email_message = email_message
    @events = @email_message.events
    @sender = @email_message.sender
    @recipient = recipient
    set_time_zone(@email_message.unit)

    set_attachments

    @events.each do |event|
      if event.ical.present?
        # attachments.inline[File.basename(event.ical.path)] = {mime_type: 'text/calendar', content: File.read(event.ical.current_path)}
        attachments[File.basename(event.ical.path)] = {mime_type: event.ical_content_type, content: File.read(event.ical.current_path)}
      end
    end

    mail from: @sender.email,
         to: @recipient.email,
         subject: @email_message.subject_with_unit,
         template_name: 'email_blast'
  end


  def set_attachments
    if @email_message.has_attachments?
      @email_message.email_attachments.each do |email_attachment|
        attachments["#{email_attachment.original_file_name}"] = File.read(email_attachment.attachment.current_path)
      end
    end
  end
end
