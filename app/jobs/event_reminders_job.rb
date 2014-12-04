class EventRemindersJob < ActiveJob::Base
  queue_as :default

  def perform
    # find all the events that need reminds and send them out
    # each reminder (sms or email) will be enqued separately

    events = Event.needs_reminders
    Event.reminder_logger.info "#{events.size} events need reminders"
    events.find_each(batch_size: 100) do |event|
      event.send_reminder
    end
  end
end
