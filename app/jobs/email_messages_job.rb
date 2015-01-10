class EmailMessagesJob < ActiveJob::Base
  queue_as :default

  def perform(email_message)
    email_message.recipients.each do |user|
      MessageMailer.email_blast(user, email_message).deliver_later
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
