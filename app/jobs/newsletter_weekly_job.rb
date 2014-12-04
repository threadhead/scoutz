class NewsletterWeeklyJob < ActiveJob::Base
  queue_as :default

  def perform
    Unit.find_each { |unit| Newsletters.weekly(unit).deliver_later }
  end
end
