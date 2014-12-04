namespace :send_newsletter do
  desc "send weekly newsletter to each unit"
  task :weekly => [:environment] do
    NewsletterWeeklyJob.perform_later
  end

  desc "send monthly newsletter to each unit"
  task :monthly => [:environment] do
    NewsletterMonthlyJob.perform_later
  end
end
