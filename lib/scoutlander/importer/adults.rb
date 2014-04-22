# This class will crawl a Unit's site on Scoutlander and populate Scoutlander::Datum objects
# with the information it scrapes. It will NOT persist any data.


module Scoutlander
  module Importer
    class Adults < Scoutlander::Importer::Base
      attr_accessor :adults

      def initialize(options={})
        super(options)
        @adults = []
      end


      # just scrape for unit audults (name and profile id/href), no scout info
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


      # scrape the Adult Search page table and populate adult name/url/uid and related scout name/url/uid
      def fetch_unit_adults_with_scouts(unit_id)
        unit = Unit.find(unit_id)
        login

        adults_page = @agent.get("/securesite/parentmain.aspx?UID=#{3218}")
        # puts adults_page.inspect
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


      # scrape an adult show page and populate all data
      def fetch_adult_info(dautm)
        fetch_person_info(datum, "ParentProfile")
      end

      # scrape a scout show page and populate all data
      def fetch_scout_info(dautm)
        fetch_person_info(dautm, "ScoutProfile")
      end

      def fetch_person_info(datum, profile_name)
        person_page = person_info_page(datum)

        datum.unit_role = person_page.search("td#ctl00_mainContent_#{profile_name}_txtRole").text
        datum.first_name = person_page.search("td#ctl00_mainContent_#{profile_name}_txtFirstName").text
        datum.last_name = person_page.search("td#ctl00_mainContent_#{profile_name}_txtLastName").text
        datum.security_level = person_page.search("td#ctl00_mainContent_#{profile_name}_txtSecurityLevel").text
        datum.email = person_page.search("td#ctl00_mainContent_#{profile_name}_txtEmail").text
        datum.alt_email = person_page.search("td#ctl00_mainContent_#{profile_name}_txtAltEmail").text
        datum.event_reminders = person_page.search("td#ctl00_mainContent_#{profile_name}_txtEventNotification").text

        datum.home_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtHomePhone").text
        datum.work_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtWorkPhone").text
        datum.cell_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtCellPhone").text

        datum.street = person_page.search("td#ctl00_mainContent_#{profile_name}_txtStreet").text
        datum.city = person_page.search("td#ctl00_mainContent_#{profile_name}_txtCity").text
        datum.state = person_page.search("td#ctl00_mainContent_#{profile_name}_txtState").text
        datum.zip_code = person_page.search("td#ctl00_mainContent_#{profile_name}_txtZip").text

        datum.inspected = true

        person_page
      end


      # scrape Scoutlander for the passed adult, popluate their info, and add scout links (but no scout info)
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


      # goto the adult show page
      def adult_info_page(datum)
        return nil if datum.url.blank?
        login
        @agent.get(datum.url)
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
