class NewsletterMonthlyJob < ActiveJob::Base
  queue_as :default

  def perform
    Unit.find_each do |unit|
      unit.users.gets_monthly_newsletter do |user|
        Newsletters.monthly(user, unit).deliver_later
      end
    end
  end
end
