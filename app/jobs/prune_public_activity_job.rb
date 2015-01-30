class PrunePublicActivityJob < ActiveJob::Base
  queue_as :default

  def perform(days_to_prune: 60)
    PublicActivity::Activity.where("updated_at < ?", days_to_prune.days.ago).destroy_all
  end
end
