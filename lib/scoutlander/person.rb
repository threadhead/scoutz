module Scoutlander
  class Person
    def initialize(options={})
      @url = options[:url]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @unit_number = options[:unit_number]
      @sub_unit = options[:sub_unit]
      @unit_role = options[:unit_role]
      @security_level = options[:security_level]
      @email = options[:email]
      @alt_email = options[:alt_email]
      @event_reminders = options[:event_reminders]
      @home_phone = options[:home_phone]
      @work_phone = options[:work_phone]
      @cell_phone = options[:cell_phone]
      @street = options[:street]
      @city = options[:city]
      @state = options[:state]
      @zip_code = options[:zip_code]
      @relations = []
    end

    attr_accessor :first_name, :last_name, :unit_number, :unit_number, :unit_role, :security_level, :email , :alt_email, :event_reminders, :home_phone, :work_phone, :cell_phone, :street , :city , :state , :zip_code, :url

    def add_relation(relation)
      @relations << relation
    end
  end

end
