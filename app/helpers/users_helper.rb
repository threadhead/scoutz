module UsersHelper
  def organization_adults_link_list(organization, users)
    users.map { |user| link_to(user.full_name, organization_adult_path(organization, user)) }.join(', ').html_safe
  end

  def scout_adults_link_list(organization, scout)
    scout.adults.map { |user| link_to(user.full_name, organization_adult_path(organization, user)) }.join(', ').html_safe
  end

  def birthdate_and_years_old(user)
    if user.birth
      "#{user.birth.to_s(:long)} (#{user.age} years old)"
    end
  end
end
