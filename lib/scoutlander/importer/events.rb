module Scoutlander
  module Importer
    class Events < Scoutlander::Importer::Base

      def perform
        event_importer = Scoutlander::Reader::Events.new(email: @email, password: @password, unit: @unit)

        if @vcr
          VCR.use_cassette('fetch_unit_events') { event_importer.fetch_unit_events }
          VCR.use_cassette('fetch_all_event_info_and_create') { event_importer.fetch_all_event_info_and_create }
        else
          event_importer.fetch_unit_events
          event_importer.fetch_all_event_info_and_create
        end
      end

    end
  end
end
