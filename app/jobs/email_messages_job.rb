class EmailMessagesJob < ActiveJob::Base
  queue_as :default

  def perform(email_message)
    if email_message.events_have_signup?
      # emails will contain individual links for signup
      email_message.recipients.each { |recipient| MessageMailer.email_blast_with_event(email_message, recipient).deliver_later
      }

    else
      MessageMailer.email_blast_no_events(email_message).deliver_later
    end
    email_message.update_attribute(:sent_at, Time.zone.now)
  end

  # def before
  #   Delayed::Worker.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> EmailMessagesJob/BEFORE"
  # end

  # def after
  #   Delayed::Worker.logger.info puts ">>>>>>>>>>>>>>>>>>>>>>>>> EmailMessagesJob/AFTER"
  # end

  # def success
  #   Delayed::Worker.logger.info puts ">>>>>>>>>>>>>>>>>>>>>>>> EmailMessagesJob/SUCCESS"
  # end
end
