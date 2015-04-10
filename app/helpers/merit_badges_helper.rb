module MeritBadgesHelper
  def cache_key_for_merit_badges(merit_badges)
    # count = merit_badges.size
    # max_updated_at = merit_badges.maximum(:updated_at).try(:utc).try(:to_s, :number)
    count_max = [merit_badges.size, merit_badges.maximum(:updated_at)].map(&:to_i).join('-')
    "merit_badges/index-#{count_max}"
  end

end
