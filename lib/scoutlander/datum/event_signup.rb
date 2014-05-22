module Scoutlander
  module Datum
    class EventSignup < Scoutlander::Datum::Base

      def initialize(options={})
        @attributes = [
          :scouts_attending,
          :siblings_attending,
          :adults_attending,
          :comment,
          :sl_profile,
          :inspected
        ]
        create_setters_getters_instance_variables(options)

        @scouts_attending = 0 if scouts_attending.nil?
        @siblings_attending = 0 if siblings_attending.nil?
        @adults_attending = 0 if adults_attending.nil?
      end

      def valid?
        @inspected && (@scouts_attending > 0 || @siblings_attending > 0 || @adults_attending > 0)
      end

      def to_params
        to_params_without(:inspected, :sl_profile)
      end

    end
  end
end
