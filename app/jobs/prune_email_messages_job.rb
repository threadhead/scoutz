class PruneEmailMessagesJob < ActiveJob::Base
  queue_as :default

  # we only keep email messages for 1.5 years (but give them an extra month to be nice)
  def perform
    pruner_log = Logger.new("#{Rails.root}/log/prune_email_messages.log")
    pruner_log.info "RUNNING"

    EmailMessage.where('created_at < ?', (1.year.ago - 7.months)).find_each(batch_size: 100) do |email_message|
      pruner_log.info "  EmailMessage: #{email_message.id}, #{email_message.subject}, user: #{email_message.user_id}, sent: #{email_message.sent_at} - destroyed"
      email_message.destroy
    end

    pruner_log.info "COMPLETED"
    pruner_log.close
  end

end
