module Scoutlander
  module Datum
    class SubUnit
      attr_accessor :name

      def initialize(options={})
        @name = options[:name]
        # @uid = options[:uid]
      end

    end
  end
end
