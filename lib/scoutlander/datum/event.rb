module Scoutlander
  module Datum
    class Event < Scoutlander::Datum::Base
      def initialize(options={})
        @attributes = [
          :inspected,
          :sl_url,
          :sl_uid,
          :sl_profile,
          :kind,
          :kind_sub_units,
          :name,
          :organizer_user,
          :send_reminders,
          :start_at,
          :end_at,
          :signup_required,
          :signup_deadline,
          :location_name,
          :location_address1,
          :location_address2,
          :location_city,
          :location_state,
          :location_zip_code,
          :location_map_url,
          :attire,
          :message,
          :fees,
          :event_signups
        ]

        create_setters_getters_instance_variables(options)
        @event_signups = []
      end

      def add_signup(event_signup)
        return unless event_signup.is_a? Scoutlander::Datum::EventSignup
        @event_signups << event_signup if event_signup.valid?
      end

      def to_params
        to_params_without(:inspected, :kind_sub_units, :organizer_user, :event_signups, :sl_url)
      end
    end
  end
end
