module Scoutlander
  module Importer
    class Scouts < Scoutlander::Importer::Base

      def perform
        scout_importer = Scoutlander::Reader::Scouts.new(email: @email, password: @password, unit: @unit, disable_all_notifications: false)

        if @vcr
          VCR.use_cassette('fetch_unit_persons(:scout)') { scout_importer.fetch_unit_scouts }
          VCR.use_cassette('fetch_all_scout_info_and_create') { scout_importer.fetch_all_scout_info_and_create }
        else
          scout_importer.fetch_unit_scouts
          scout_importer.fetch_all_scout_info_and_create
        end
      end

    end
  end
end
