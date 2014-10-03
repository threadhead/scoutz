class IcalFilesUpdateAllJob < ActiveJob::Base
  queue_as :default

  def perform
    # Event.pluck(:id).each{ |event_id| Event.delay(priority: -5).update_ical(event_id) }
    Event.find_each(batch_size: 100) do |event|
      IcalFilesUpdateJob.perform_later(event)
    end
  end
end
