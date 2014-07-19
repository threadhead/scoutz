# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
job_type :rake_logged, "cd :path && :environment_variable=:environment bundle exec rake :task :output"

set :output, '/home/karl/scoutz/shared/log/cron.log'

# every 30.minutes do
#   runner "Event.delay.send_reminders"
# end

# every :friday, at: '9:17am' do
#   rake_logged "send_newsletter:weekly"
# end

# every :month, at: '12:17am' do
#   rake_logged "send_newsletter:monthly"
# end
