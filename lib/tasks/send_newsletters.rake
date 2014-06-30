namespace :send_newsletter do
  desc "send weekly newsletter to each unit"
  task :weekly => [:environment] do
    Unit.all.each { |unit| Newsletters.delay.weekly(unit.id) }
  end

  desc "send monthly newsletter to each unit"
  task :monthly => [:environment] do
    Unit.all.each { |unit| Newsletters.delay.monthly(unit.id) }
  end
end
