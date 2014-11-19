module Scoutlander
  module Importer
    class Base

      def initialize(email:, password:, unit:, vcr: false)
        @email = email
        @password = password
        @unit = unit
        @vcr = vcr
      end

    end
  end
end
