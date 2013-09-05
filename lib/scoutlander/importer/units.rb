module Scoutlander
  module Importer
    class Units < Scoutlander::Importer::Base
      attr_reader :units

      def initialize(options={})
        super(options)
        @units = []
      end


      def available_names_uids
        dash_page = login
        sites = dash_page.search("a.mysites")
        sites.each do |site|
          uid = uid_from_url(site['href'])
          name = site.child.text.strip
          @units << Scoutlander::Datum::Unit.new(uid: uid, name: name)
        end
        logout
        # @units = dash_page.search("a.mysites").children.map(&:text)
        @units
      end

      def unit_info(uid)
        unit = Scoutlander::Datum::Unit.new(uid: uid)
        dash_page = login
        adv_settings = @agent.get("http://www.scoutlander.com/securesite/adminmain.aspx?UID=#{uid}")

        city_state = adv_settings.search("td#ctl00_lblUnitTitle").first.children[2].text

        unit.city, unit.state = split_city_state(city_state)

        unit.time_zone = adv_settings.form("aspnetForm").field_with("ctl00$mainContent$adminconfigure$cmbTimeZone").value
        #TODO - incomplete, not sure if even necessary, just have user enter the few basic fields
      end

      def split_city_state(str)
        if str
          str.strip!
          city = str.split(',').first.strip
          state = str.split(',').last.strip
          return city, state
        end
      end


    end
  end
end
