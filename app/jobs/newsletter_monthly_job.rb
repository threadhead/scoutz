class NewsletterMonthlyJob < ActiveJob::Base
  queue_as :default

  def perform
    # we want to send the monthly newsletter 5 days before the end of the month
    return unless Date.today == Date.new(Date.today.year, Date.today.month, -5)

    Unit.find_each do |unit|

      # don't send the newslertter if it has already been sent this month
      if unit.monthly_newsletter_sent_at.nil? || unit.monthly_newsletter_sent_at.month != Date.today.month
        unit.users.gets_monthly_newsletter.each do |user|
          Newsletters.monthly(user, unit).deliver_later
        end
        unit.update_column(:monthly_newsletter_sent_at, Time.zone.now)
      end

    end
  end
end
