module UsersHelper
  def organization_adults_link_list(organization, users)
    users.map { |user| link_to(user.full_name, organization_adult_path(organization, user)) }.join(', ').html_safe
  end

  def organization_scouts_link_list(organization, users)
    users.map { |user| link_to(user.full_name, organization_scout_path(organization, user)) }.join(', ').html_safe
  end

  def scout_adults_link_list(organization, scout)
    scout.organization_adults(organization).map { |user| link_to(user.full_name, organization_adult_path(organization, user)) }.join(', ').html_safe
  end

  def adult_scouts_link_list(organization, adult)
    adult.organization_scouts(organization).map { |user| link_to(user.full_name, organization_scout_path(organization, user)) }.join(', ').html_safe
  end

  def adult_sub_units_list(organization, adult)
    adult.sub_units(organization).map(&:name).join(', ')
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
    sanitize(user.address1.to_s) + add_break(user.address1) +
    sanitize(user.address2.to_s) + add_break(user.address2) +
    sanitize(user_city_state_zip(user)) + add_break(user_city_state_zip(user))
  end

end
