namespace :events do
  desc "send reminders for events"
  task :send_reminders => [:environment] do
    Event.send_reminders
  end
end
