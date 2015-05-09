class NewsletterWeeklyJob < ActiveJob::Base
  queue_as :default

  def perform
    Unit.find_each do |unit|
      unit.users.gets_weekly_newsletter.each do |user|
        if unit.weekly_newsletter_sent_at.nil? || unit.weekly_newsletter_sent_at.to_date.cweek != Date.today.cweek
          Newsletters.weekly(user, unit).deliver_later
        end
      end

      unit.update_column(:weekly_newsletter_sent_at, Time.zone.now)
    end
  end
end
