module Scoutlander
  module Datum
    class Page < Scoutlander::Datum::Base
      def initialize(options={})
        @attributes = [
          :inspected,
          :sl_url,
          :sl_uid,
          :title,
          :body
        ]

        create_setters_getters_instance_variables(options)
      end

      def to_params
        to_params_without(:inspected, :sl_uid, :sl_url)
      end
    end
  end
end
