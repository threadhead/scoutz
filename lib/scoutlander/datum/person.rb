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
          :rank,
          :sl_url,
          :sl_uid,
          :sl_profile,
          :relations,
          :parent,

          :blast_email,
          :blast_sms,
          :event_reminder_email,
          :event_reminder_sms,
          :signup_deadline_email,
          :signup_deadline_sms,
          :weekly_newsletter_email,
          :monthly_newsletter_email,
          :sms_message
        ]
        create_setters_getters_instance_variables(options)
        @relations = []
        @parent = nil

        @blast_email = false
        @blast_sms = false
        @event_reminder_email = false
        @event_reminder_sms = false
        @signup_deadline_email = false
        @signup_deadline_sms = false
        @weekly_newsletter_email = false
        @monthly_newsletter_email = false
        @sms_message = false

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
        to_params_without(:inspected, :sub_unit, :relations, :parent, :security_level, :home_phone, :work_phone, :cell_phone, :sl_url)
      end

    end
  end
end
