module UsersHelper
  def unit_adults_link_list(unit, users)
    users.map { |user| link_to(user.full_name, unit_adults_path(unit, user)) }.join(', ').html_safe
  end

  def unit_scouts_link_list(unit, users)
    users.map { |user| link_to(user.full_name, unit_scout_path(unit, user)) }.join(', ').html_safe
  end

  def scout_adults_link_list(unit, scout)
    scout.unit_adults(unit).map { |user| link_to(user.full_name, unit_adults_path(unit, user)) }.join(', ').html_safe
  end

  def adult_scouts_link_list(unit, adult)
    adult.unit_scouts(unit).map { |user| link_to(user.full_name, unit_scout_path(unit, user)) }.join(', ').html_safe
  end

  def adult_sub_units_list(unit, adult)
    adult.sub_units(unit).map(&:name).join(', ')
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
