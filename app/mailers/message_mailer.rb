class MessageMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  def email_blast(sender, recipients, email_message, recipient_user=nil)
    @email_message = email_message
    @events = @email_message.events
    @recipient_user = recipient_user

    if @email_message.has_attachments?
      @email_message.email_attachments.each do |email_attachment|
        attachments["#{email_attachment.original_file_name}"] = File.read(email_attachment.attachment.current_path)
      end
    end

    mail from: sender.email,
         to: recipients,
         subject: email_message.subject_with_unit
  end
end
