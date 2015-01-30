class PruneEmailMessagesJob < ActiveJob::Base
  queue_as :default

  # we only keep email messages for 1.5 years (but give them an extra month to be nice)
  def perform
    EmailMessage.where('created_at < ?', (1.year.ago - 7.months)).find_each(batch_size: 100) do |email_message|
      email_message.destroy
    end
  end

end
