namespace :events do
  desc "send reminders for events"
  task :send_reminders => [:environment] do
    EventRemindersJob.perform_later
  end
end
