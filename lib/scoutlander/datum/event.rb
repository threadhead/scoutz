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
            :organizer_profile,
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
            :location_url,
            :attire,
            :message,
            :fees
          ]

        create_setters_getters_instance_variables(options)
      end

      def to_params
          to_params_without(:inspected, :kind_sub_units)
      end
    end
  end
end
