namespace :send_newsletter do
  desc "send weekly newsletter to each unit"
  task :weekly => [:environment] do
    Unit.all.each { |unit| Newsletters.weekly(unit).deliver_later }
  end

  desc "send monthly newsletter to each unit"
  task :monthly => [:environment] do
    Unit.all.each { |unit| Newsletters.monthly(unit).deliver_later }
  end
end
