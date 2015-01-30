class PrunePublicActivityJob < ActiveJob::Base
  queue_as :default

  def perform(days_to_prune=60)
  # def perform(days_to_prune: 60)
    pruner_log = Logger.new("#{Rails.root}/log/prune_email_messages.log")
    pruner_log.info "RUNNING"

    activities = PublicActivity::Activity.where("updated_at < ?", days_to_prune.days.ago)
    pruner_log.info "  Activities: pruning +#{days_to_prune} days, count: #{activities.count}"
    activities.destroy_all

    pruner_log.info "COMPLETED"
    pruner_log.close
  end
end
