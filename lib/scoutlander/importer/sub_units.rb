module Scoutlander
  module Importer
    class SubUnits < Scoutlander::Importer::Base
      attr_reader :sub_units

      def initialize(options={})
        super(options)
        @sub_units = []
      end


      # returns an array of Scoutlander::Datum::SubUnits with the name of each sub unit
      def fetch_sub_units
        @logger.info "EXEC(SUB_UNITS) : Unit=#{@unit.name}, #{@unit.unit_number}"

        # sub_units (dens, patrols, etc.) are on the setup wizard page, item #3
        # listed in a table, with the second column the list of names
        dash_page = login
        unit_page = dash_page.link_with(text: %r{#{@unit.unit_number}}).click
        @logger.info "CLICK : Site Setup Wizard"
        site_setup_wizard_page = unit_page.link_with(:text => %r/Site Setup Wizard/).click
        @logger.info "CLICK : Add Dens or Patrols"
        add_dens_page = site_setup_wizard_page.link_with(:text => %r/Add Dens or Patrols/).click
        sub_unit_names = add_dens_page.search("table#ctl00_mainContent_adminsubunitmgr_tblData tr td[2]").children.map(&:text)
        @logger.info "SUB UNIT NAMES : #{sub_unit_names.join(', ')}"
        logout

        unless sub_unit_names.nil? || sub_unit_names.empty?
          sub_unit_names = remove_dups(remove_empties(sub_unit_names)).map(&:strip)
          sub_unit_names.delete('Patrols')
          @sub_units = sub_unit_names.map{ |su| Scoutlander::Datum::SubUnit.new(name: su, inspected: true) }
        end
      end

      def remove_dups(arr)
        arr.nil? ? arr : arr.uniq
      end

      def remove_empties(arr)
        arr.nil? ? arr : arr.reject(&:empty?)
      end
    end
  end
end
