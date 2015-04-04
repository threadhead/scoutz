module MeritBadgesHelper
  def cache_key_for_merit_badges(merit_badges)
    count = merit_badges.size
    max_updated_at = merit_badges.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "merit_badges/index-#{count}-#{max_updated_at}"
  end

end
