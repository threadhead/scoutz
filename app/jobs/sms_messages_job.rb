class SmsMessagesJob < ActiveJob::Base
  queue_as :default

  def perform(sms_message)
    sms_message.recipients.each do |recipient|
      TextMessage.sms_message(recipient.sms_email_address, sms_message).deliver_later
    end
    sms_message.update_attribute(:sent_at, Time.zone.now)
  end
end
