module SendToOptions
  extend ActiveSupport::Concern

  # included do
  # end

  class_methods do
    def send_to_options(unit)
      [
        ["Everyone in #{unit.name}", 1],
        ["Email Group", 8],
        ["#{unit.name} Leaders", 2],
        ["Selected #{unit.sub_unit_name.pluralize}", 3],
        ["Selected Adults/Scouts", 4],
        ["Scoutmasters (SM/ASM)", 5],
        ["Committee Members", 6],
        ["Cubmaster/ACM/Den Leaders", 7]
      ].reject { |a| options_to_reject(unit).include? a[1] }
    end

    def options_to_reject(unit)
      rejected = case unit.unit_type
      when "Boy Scouts"
        [7,6]
      when "Cub Scouts"
        [5,6,7]
      when "Venturing Crew"
        [7,5,6]
      when "Girl Scouts"
        [7,5,6]
      when "Order of the Arrow"
        [7,5,6]
      end

      if unit.email_groups.size == 0
        rejected << 8
      end
      rejected
    end
  end




  def send_to(to_unit=self.unit)
    case send_to_option
    when 1
      "Everyone in #{to_unit.name}"
    when 8
      "Email Group: #{email_group.try(:name)}"
    when 2
      "All #{to_unit.name} Leaders"
    when 3
      "Selected #{to_unit.sub_unit_name.pluralize}"
    when 4
      "Selected Adults/Scouts"
    when 5
      "Scoutmasters (SM/ASM)"
    when 6
      "Committee Members"
    when 7
      "Cubmaster/ACM/Den Leaders"
    end
  end


  def send_to_unit?
    send_to_option == 1
  end

  def send_to_leaders?
    send_to_option == 2
  end

  def send_to_sub_units?
    send_to_option == 3
  end

  def send_to_users?
    send_to_option == 4
  end

  def send_to_scoutmasters?
    send_to_option == 5
  end

  def send_to_committee?
    send_to_option == 6
  end

  def send_to_cubmasters_den_leaders?
    send_to_option == 7
  end

  def send_to_group?
    send_to_option == 8

  end

end
