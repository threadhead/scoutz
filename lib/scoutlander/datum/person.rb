module Scoutlander
  module Datum

    class Person < Scoutlander::Datum::Base
      def initialize(options={})
        @attributes = [
          :inspected,
          :first_name,
          :last_name,
          :sub_unit,
          :leadership_role,
          :security_level,
          :email ,
          :alternate_email,
          :send_reminders,
          :home_phone,
          :work_phone,
          :cell_phone,
          :address1 ,
          :city,
          :state,
          :zip_code,
          :sl_url,
          :sl_uid,
          :sl_profile,
          :relations,
          :parent
        ]
        create_setters_getters_instance_variables(options)
        @relations = []
        @parent = nil
      end

      def name
        "#{@first_name} #{@last_name}"
      end

      def add_relation(person)
        return unless person.is_a? Scoutlander::Datum::Person
        @relations << person
        person.parent = self
      end

      def to_params
        to_params_without(:inspected, :relations, :parent, :security_level, :home_phone, :work_phone, :cell_phone, :sl_url)
      end

    end
  end
end
