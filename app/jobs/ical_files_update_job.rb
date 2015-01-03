class IcalFilesUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(event)
    event.update_ical
  end
end
