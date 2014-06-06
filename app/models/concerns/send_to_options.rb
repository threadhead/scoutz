module SendToOptions
  extend ActiveSupport::Concern

  # included do
  # end

  module ClassMethods
    def send_to_options(unit)
      [
        ["Everyone in #{unit.name}", 1],
        ["#{unit.name} Leaders", 2],
        ["Selected #{unit.sub_unit_name.pluralize}", 3],
        ["Selected Adults/Scouts", 4]
      ]
    end
  end


  def send_to(to_unit=self.unit)
    case send_to_option
    when 1
      "Everyone in #{to_unit.name}"
    when 2
      "All #{to_unit.name} Leaders"
    when 3
      "Selected #{to_unit.sub_unit_name.pluralize}"
    when 4
      "Selected Adults/Scouts"
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

end
