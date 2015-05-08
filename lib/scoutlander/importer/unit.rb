module Scoutlander
  module Importer
    class Unit < Scoutlander::Importer::Base

      def perform
        if @vcr
          VCR.use_cassette('fetch_sub_units') {}
        else
        end
      end

    end
  end
end
