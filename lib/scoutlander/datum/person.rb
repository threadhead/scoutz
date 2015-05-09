module Scoutlander
  module Datum
    class Person < Scoutlander::Datum::Base
      def initialize(options={})
        @attributes = [
          :inspected,
          :first_name,
          :last_name,
          :sub_unit,
          :leadership_position,
          :additional_leadership_positions,
          :security_level,
          :email,
          :alternate_email,
          :send_reminders,
          :home_phone,
          :work_phone,
          :cell_phone,
          :address1,
          :city,
          :state,
          :zip_code,
          :rank,
          :role,
          :sl_url,
          :sl_uid,
          :sl_profile,
          :role,
          :relations,
          :parent
        ]
        create_setters_getters_instance_variables(options)
        @relations = []
        @parent = nil
        @role = 'basic'
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
        to_params_without(:inspected, :sub_unit, :relations, :parent, :security_level, :home_phone, :work_phone, :cell_phone, :sl_url, :leadership_position, :additional_leadership_positions)
      end
    end
  end
end
