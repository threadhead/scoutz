class NewsletterMonthlyJob < ActiveJob::Base
  queue_as :default

  def perform
    Unit.find_each { |unit| Newsletters.monthly(unit).deliver_later }
  end
end
