namespace :events do
  desc 'update all ical files'
  task update_all_ical: [:environment] do
    IcalFilesUpdateAllJob.perform_later
  end
end
