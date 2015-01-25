# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :output, '/home/deploy/scoutz/shared/log/cron.log'

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
job_type :backup, "cd /home/deploy/Backup && ~/.rvm/bin/rvm 2.2.0 do bundle exec backup perform -t :task :output"


every 30.minutes do
  runner "EventRemindersJob.perform_later"
end

every :friday, at: '9:17am' do
  runner "NewsletterWeeklyJob.perform_later"
end

# the job will check and only run on the 5th from the last day of the month
#  but we need to cover all days for all months, e.g. Feb 14, Apr 26, Jan 27
every '17 3 23-28 * *' do
  runner "NewsletterMonthlyJob.perform_later"
end

every :day, at: '12:20am' do
  backup 'scoutz_db'
end

# every :month, at: '12:17am' do
#   rake_logged "send_newsletter:monthly"
# end
