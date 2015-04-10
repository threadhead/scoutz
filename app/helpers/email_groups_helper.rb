module EmailGroupsHelper
  def cache_key_for_email_groups(email_groups)
    # count = email_groups.size
    # max_updated_at = email_groups.maximum(:updated_at).try(:utc).try(:to_s, :number)
    # count_max = email_groups.pluck("COUNT(*)", "MAX(updated_at)")[0].map(&:to_i)
    [email_groups.size, email_groups.maximum(:updated_at)].map(&:to_i)
    "email_groups/index-#{count_max.join('-')}"
  end
end
