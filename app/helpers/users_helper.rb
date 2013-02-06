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

  def user_city_state_zip(user)
    "#{user.city}#{user.city.blank? ? '' : ', '}#{user.state} #{user.zip_code}".strip
  end


  def user_address_show(user)
    sanitize(user.address1) + add_break(user.address1) +
    sanitize(user.address2) + add_break(user.address2) +
    sanitize(user_city_state_zip(user)) + add_break(user_city_state_zip(user))
  end

end
