module UsersHelper
  def unit_adults_link_list(unit, users)
    users.map { |user| link_to(user.full_name, unit_adult_path(unit, user)) }.join(', ').html_safe
  end

  def unit_scouts_link_list(unit, users)
    users.map { |user| link_to(user.full_name, unit_scout_path(unit, user)) }.join(', ').html_safe
  end

  def scout_adults_link_list(unit, scout)
    scout.unit_adults(unit).map { |user| link_to(user.full_name, unit_adult_path(unit, user)) }.join(', ').html_safe
  end

  def adult_scouts_link_list(unit, adult)
    adult.unit_scouts(unit).map { |user| link_to(user.full_name, unit_scout_path(unit, user)) }.join(', ').html_safe
  end

  def adult_sub_units_list(unit, adult)
    adult.sub_units(unit).map(&:name).join(', ')
  end

  def options_for_user_roles
    roles = current_user.adult? ? User.roles : User.roles_at_and_below(:leader)
    roles.keys.map{|r| [r.titleize, r]}
  end


  def birthdate_and_years_old(user)
    if user.birth
      "#{user.birth.to_s(:long)} (#{user.age} years old)"
    end
  end

  def user_city_state_zip(user)
    "#{user.city}#{user.city.blank? ? '' : ', '}#{user.state} #{user.zip_code}".strip
  end

  def corrected_unit_user_path(unit, user)
    if user.adult?
      unit_adult_path(unit, user)
    else
      unit_scout_path(unit, user)
    end
  end


  def user_address_show(user)
    sanitize(user.address1.to_s) + add_break(user.address1) +
    sanitize(user.address2.to_s) + add_break(user.address2) +
    sanitize(user_city_state_zip(user)) + add_break(user_city_state_zip(user))
  end


  def cache_key_for_users(users)
    count = users.count
    max_updated_at = users.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{users.first.type.downcase}s/index-#{count}-#{max_updated_at}"
  end
end
