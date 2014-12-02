module SubUnitsHelper
  def cache_key_for_sub_units(sub_units)
    count = sub_units.count
    max_updated_at = sub_units.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "sub_units/index-#{count}-#{max_updated_at}"
  end
end
