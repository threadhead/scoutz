class IcalFilesUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(event)
    event.update_ical
    # Event.delay(priority: -5).update_ical(self.id)
  end
end
