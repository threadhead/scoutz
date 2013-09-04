module Scoutlander
  module Importer
    class Adults < Scoutlander::Importer::Base
      attr_reader :adults

      def initialize(options={})
        super(options)
        @adults = []
      end

      def fetch_unit_adults(unit_id)
        unit = Unit.find(unit_id)
        login
        adults_page = @agent.get("/securesite/parentmain.aspx?UID=#{3218}")
        adults_page.links_with(href: /parentmain.*&profile/).each do |link|
          adult = Scoutlander::Datum::Person.new
          adult.last_name, adult.first_name = link.text.split(', ')
          adult.url = link.href
          adult.uid = uid_from_url(adult.url)
          adult.profile = profile_from_url(adult.url)
          @adults << adult
        end
        @adults
      end


      def fetch_unit_adults_with_scouts(unit_id)
        unit = Unit.find(unit_id)
        login

        adults_page = @agent.get("/securesite/parentmain.aspx?UID=#{3218}")
        # get the table rows, excluding the first two header rows
        rows = adults_page.search('table#ctl00_mainContent_ParentSearch_tblPersonSearch tr')[2..-1]
        rows.each do |row|
          adult = nil
          scouts = []

          row.children.children.each do |td|
            if td.name = 'a'
              if td['href'] =~ /parentmain/
                adult = Scoutlander::Datum::Person.new
                adult.last_name, adult.first_name = td.text.split(', ')
                adult.url = td['href']
                adult.uid = uid_from_url(adult.url)
                adult.profile = profile_from_url(adult.url)

              elsif td['href'] =~ /scoutmain/
                scout = Scoutlander::Datum::Person.new
                scout.url = td['href']
                scout.uid = uid_from_url(scout.url)
                scout.profile = profile_from_url(scout.url)
                scouts << scout
              end
            end

            if adult
              scouts.each{ |scout| adult.add_relation(scout) }
            end
          end

          @adults << adult
        end

        @adults
      end

      def fetch_adult_info(adult_datum)
        adult_page = adult_info_page(adult_datum)

        adult_datum.unit_role = adult_page.search("td#ctl00_mainContent_ParentProfile_txtRole").text
        adult_datum.first_name = adult_page.search("td#ctl00_mainContent_ParentProfile_txtFirstName").text
        adult_datum.last_name = adult_page.search("td#ctl00_mainContent_ParentProfile_txtLastName").text
        adult_datum.security_level = adult_page.search("td#ctl00_mainContent_ParentProfile_txtSecurityLevel").text
        adult_datum.email = adult_page.search("td#ctl00_mainContent_ParentProfile_txtEmail").text
        adult_datum.alt_email = adult_page.search("td#ctl00_mainContent_ParentProfile_txtAltEmail").text
        adult_datum.event_reminders = adult_page.search("td#ctl00_mainContent_ParentProfile_txtEventNotification").text

        adult_datum.home_phone = adult_page.search("td#ctl00_mainContent_ParentProfile_txtHomePhone").text
        adult_datum.work_phone = adult_page.search("td#ctl00_mainContent_ParentProfile_txtWorkPhone").text
        adult_datum.cell_phone = adult_page.search("td#ctl00_mainContent_ParentProfile_txtCellPhone").text

        adult_datum.street = adult_page.search("td#ctl00_mainContent_ParentProfile_txtStreet").text
        adult_datum.city = adult_page.search("td#ctl00_mainContent_ParentProfile_txtCity").text
        adult_datum.state = adult_page.search("td#ctl00_mainContent_ParentProfile_txtState").text
        adult_datum.zip_code = adult_page.search("td#ctl00_mainContent_ParentProfile_txtZip").text

        adult_datum.inspected = true

        adult_page
      end

      def fetch_adult_info_with_scout_links(adult_datum)
        adult_page = fetch_adult_info(adult_datum)

        if adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").size > 0
          adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").each do |scout|
            profile = profile_from_url(scout['href'])
            adult_scout = find_or_create_by_profile(profile)
            adult_scout.profile = profile
            adult_scout.url = scout['href']
            adult_scout.uid = uid_from_url(scout['href'])

            if adult_scout.parent.nil?
              adult_datum.add_relation adult_scout
            end
          end
        end
      end

      def adult_info_page(adult_datum)
        return nil if adult_datum.uid.blank? || adult_datum.profile.blank?
        login
        agent.get("/securesite/parentmain.aspx?UID=#{adult_datum.uid}&profile=#{adult_datum.profile}")
      end


      def find_or_create_by_profile(profile)
        @adults.each do |adult|
          return adult if adult.profile == profile
          adult.relations.each do |relation|
            return relation if relation.profile == profile
          end
        end

        Scoutlander::Datum::Person.new
      end

    end
  end
end
