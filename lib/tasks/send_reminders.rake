namespace :events do
  desc "send reminders for events"
  task :send_reminders => [:environment] do
    # Event.delay.send_reminders
    EventRemindersJob.send_reminders_later
  end
end
