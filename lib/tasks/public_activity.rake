namespace :public_activity do
  namespace :prune do
    # desc "prune PA older than 30 days"
    # task :30 => [:environment] do
    #   PublicActivity::Activity.where("updated_at < ?", 30.days.ago).destroy_all
    # end

    desc "prune PA older than 60 days"
    task d60: [:environment] do
      PrunePublicActivityJob.perform_later(60)
    end

    desc "prune PA older than 90 days"
    task d90: [:environment] do
      PrunePublicActivityJob.perform_later(90)
    end

    desc "prune PA older than 120 days"
    task d120: [:environment] do
      PrunePublicActivityJob.perform_later(120)
    end
  end
end
