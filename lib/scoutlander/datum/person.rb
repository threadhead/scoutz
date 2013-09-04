module Scoutlander
  module Datum

    class Person
      attr_accessor :inspected, :first_name, :last_name, :unit_number, :unit_number, :unit_role, :security_level, :email , :alt_email, :event_reminders, :home_phone, :work_phone, :cell_phone, :street , :city , :state , :zip_code, :url, :uid, :profile, :relations, :parent

      def initialize(options={})
        @inspected = options[:inspected] || false
        @url = options[:url]
        @uid = options[:uid]
        @profile = options[:profile]
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
        @parent = nil
      end


      def add_relation(person)
        return unless person.is_a? Scoutlander::Datum::Person
        @relations << person
        person.parent = self
      end

    end
  end
end
