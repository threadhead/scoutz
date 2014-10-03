class EmailMessagesJob < ActiveJob::Base
  queue_as :default

  def perform(email_message)
    if email_message.events_have_signup?
      # emails will contain individual links for signup
      email_message.recipients.each { |recipient| MessageMailer.email_blast( email_message.sender.id,
                                                                             recipient.email,
                                                                             email_message.id,
                                                                             recipient.id
                                                                             ).deliver_later
      }

    else
      MessageMailer.email_blast(self.sender.id, recipients_emails, self.id).deliver_later
    end
    email_message.update_attribute(:sent_at, Time.zone.now)

end
