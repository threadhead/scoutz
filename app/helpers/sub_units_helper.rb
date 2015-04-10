module SubUnitsHelper
  def cache_key_for_sub_units(sub_units)
    # count = sub_units.size
    # max_updated_at = sub_units.maximum(:updated_at).try(:utc).try(:to_s, :number)
    count_max = [sub_units.size, sub_units.maximum(:updated_at)].map(&:to_i).join('-')
    "sub_units/index-#{count_max}"
  end
end
