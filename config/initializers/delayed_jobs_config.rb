Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
# Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.sleep_delay = 60
# Delayed::Worker.max_attempts = 3
# Delayed::Worker.max_run_time = 5.minutes

Delayed::Worker.delay_jobs = ::Rails.env.production? || ::Rails.env.staging?
# Delayed::Worker.delay_jobs = false
# Delayed::Worker.delay_jobs = true
