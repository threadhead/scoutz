module Scoutlander
  module Importer
    class Adults < Scoutlander::Importer::Base

      def perform
        adult_importer = Scoutlander::Reader::Adults.new(email: @email, password: @password, unit: @unit, disable_all_notifications: false)

        if @vcr
          VCR.use_cassette('fetch_unit_persons(:adult)') { adult_importer.fetch_unit_adults }
          VCR.use_cassette('fetch_all_adult_info_and_create') { adult_importer.fetch_all_adult_info_and_create }
        else
          adult_importer.fetch_unit_adults
          adult_importer.fetch_all_adult_info_and_create
        end
      end

    end
  end
end
