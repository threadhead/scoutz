class NewsletterWeeklyJob < ActiveJob::Base
  queue_as :default

  def perform
    Unit.find_each do |unit|
      unit.users.gets_weekly_newsletter.each do |user|
        Newsletters.weekly(user, unit).deliver_later
      end
    end
  end
end
