class EventRemindersJob < ActiveJob::Base
  queue_as :default

  def send_reminders
    # find all the events that need reminds and send them out
    # each reminder (sms or email) will be enqued separately

    events = Event.needs_reminders
    Event.reminder_logger.info "#{events.size} events need reminders"
    events.each do |event|
      event.send_reminder
    end
  end
end
