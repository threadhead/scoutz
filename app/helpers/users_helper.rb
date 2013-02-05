module UsersHelper
  def organization_adults_link_list(organization, users)
    users.map { |user| link_to(user.full_name, organization_adult_path(organization, user)) }.join(', ').html_safe
  end
end
