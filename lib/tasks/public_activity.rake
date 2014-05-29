namespace :public_activity do
  namespace :prune do
    # desc "prune PA older than 30 days"
    # task :30 => [:environment] do
    #   PublicActivity::Activity.where("updated_at < ?", 30.days.ago).destroy_all
    # end

    desc "prune PA older than 60 days"
    task d60: [:environment] do
      PublicActivity::Activity.where("updated_at < ?", 60.days.ago).destroy_all
    end

    desc "prune PA older than 90 days"
    task d90: [:environment] do
      PublicActivity::Activity.where("updated_at < ?", 90.days.ago).destroy_all
    end

    desc "prune PA older than 120 days"
    task d120: [:environment] do
      PublicActivity::Activity.where("updated_at < ?", 120.days.ago).destroy_all
    end
  end
end
