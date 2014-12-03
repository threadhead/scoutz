module Scoutlander
  module Importer
    class Pages < Scoutlander::Importer::Base

      def perform
        page_importer = Scoutlander::Reader::Pages.new(email: @email, password: @password, unit: @unit)

        if @vcr
          VCR.use_cassette('fetch_page_links') { page_importer.fetch_page_links }
          VCR.use_cassette('fetch_all_page_info_and_create') { page_importer.fetch_all_page_info_and_create }
        else
          page_importer.fetch_page_links
          page_importer.fetch_all_page_info_and_create
        end
      end

    end
  end
end


