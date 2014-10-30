module Scoutlander
  module Importer
    class SubUnits < Scoutlander::Importer::Base

      def perform
        sub_unit_importer = Scoutlander::Reader::SubUnits.new(email: @email, password: @password, unit: @unit)

        if @vcr
          VCR.use_cassette('fetch_sub_units') { sub_unit_importer.fetch_sub_units }
        else
          sub_unit_importer.fetch_sub_units
        end

        sub_unit_importer.sub_units.each { |sub_unit| @unit.sub_units.create(sub_unit.to_params) }
      end

    end
  end
end
