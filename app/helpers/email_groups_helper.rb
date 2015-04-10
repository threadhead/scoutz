module EmailGroupsHelper
  def cache_key_for_email_groups(email_groups)
    count = email_groups.size
    max_updated_at = email_groups.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "email_groups/index-#{count}-#{max_updated_at}"
  end
end
