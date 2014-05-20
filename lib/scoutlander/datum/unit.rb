module Scoutlander
  module Datum
    class Unit < Scoutlander::Datum::Base
      attr_accessor

      def initialize(options={})
        @attributes = [
          :inspected,
          :name,
          :sl_uid,
          :type,
          :number,
          :city,
          :state,
          :time_zone
        ]

        create_setters_getters_instance_variables(options)
      end

      def to_params
        to_params_without(:inspected)
      end
    end
  end
end
