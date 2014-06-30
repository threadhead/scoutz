namespace :events do
  desc "update all ical files"
  task :update_all_ical => [:environment] do
    Event.update_all_ical
  end
end
