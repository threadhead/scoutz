module Scoutlander
  module Datum
    class SubUnit < Scoutlander::Datum::Base

      def initialize(options={})
        @attributes = [
          :name,
          :inspected
        ]
        create_setters_getters_instance_variables(options)
      end

      def to_params
        to_params_without(:inspected)
      end

    end
  end
end
