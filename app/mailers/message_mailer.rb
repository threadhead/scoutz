class MessageMailer < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(EventsHelper)

  def email_blast(sender_id, recipients, email_message_id, recipient_user_id=nil)
    @sender = User.find(sender_id)
    @email_message = EmailMessage.find(email_message_id)
    @events = @email_message.events
    @recipient_user = User.find(recipient_user_id) if recipient_user_id

    if @email_message.has_attachments?
      @email_message.email_attachments.each do |email_attachment|
        attachments["#{email_attachment.original_file_name}"] = File.read(email_attachment.attachment.current_path)
      end
    end

    mail from: @sender.email,
         to: recipients,
         subject: @email_message.subject_with_unit
  end
end
