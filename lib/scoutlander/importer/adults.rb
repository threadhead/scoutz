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

      # in general, you would first scrape the 'Adult Search' table using .fetch_unit_adults
      #  this will poplulate the @adults array with basid name, uid (user id), and url (used to get details)

      #  after the @adults are populated, you can use .fetch_adult_info_with_scout_links to get the detail
      #  info for each adult. this will also created related scouts (with uid and url) for each adult


      # just scrape for unit audults (name and profile id/href), no scout info
      def fetch_unit_adults
        login

        adults_page = @agent.get("/securesite/parentmain.aspx?UID=#{@unit.sl_uid}")
        adults_page.links_with(href: /parentmain.*&profile/).each do |link|
          adult = Scoutlander::Datum::Person.new
          adult.last_name, adult.first_name = link.text.split(', ')
          adult.sl_url = link.href
          adult.sl_uid = uid_from_url(adult.sl_url)
          adult.sl_profile = profile_from_url(adult.sl_url)
          @adults << adult
        end
      end


      # scrape the Adult Search page table and populate adult name/url/uid and related scout name/url/uid
      #  this is an early iteration and may not be used
      def fetch_unit_adults_with_scouts
        login

        adults_page = @agent.get("/securesite/parentmain.aspx?UID=#{@unit.sl_uid}")
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
                adult.sl_url = td['href']
                adult.sl_uid = uid_from_url(adult.sl_url)
                adult.sl_profile = profile_from_url(adult.sl_url)

              elsif td['href'] =~ /scoutmain/
                scout = Scoutlander::Datum::Person.new
                scout.sl_url = td['href']
                scout.sl_uid = uid_from_url(scout.sl_url)
                scout.sl_profile = profile_from_url(scout.sl_url)
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
      def fetch_adult_info(datum)
        fetch_person_info(datum, "ParentProfile")
      end

      # scrape a scout show page and populate all data
      def fetch_scout_info(datum)
        fetch_person_info(datum, "ScoutProfile")
      end

      def fetch_person_info(datum, profile_name)
        person_page = case profile_name
        when "ParentProfile"
          adult_info_page(datum)
        when "ScoutProfile"
          scout_info_page(datum)
        end

        datum.leadership_role = person_page.search("td#ctl00_mainContent_#{profile_name}_txtRole").text
        datum.first_name = person_page.search("td#ctl00_mainContent_#{profile_name}_txtFirstName").text
        datum.last_name = person_page.search("td#ctl00_mainContent_#{profile_name}_txtLastName").text
        datum.security_level = person_page.search("td#ctl00_mainContent_#{profile_name}_txtSecurityLevel").text
        datum.email = person_page.search("td#ctl00_mainContent_#{profile_name}_txtEmail").text
        datum.alternate_email = person_page.search("td#ctl00_mainContent_#{profile_name}_txtAltEmail").text
        datum.send_reminders = person_page.search("td#ctl00_mainContent_#{profile_name}_txtEventNotification").text.include?("ON")

        datum.home_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtHomePhone").text
        datum.work_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtWorkPhone").text
        datum.cell_phone = person_page.search("td#ctl00_mainContent_#{profile_name}_txtCellPhone").text

        datum.address1 = person_page.search("td#ctl00_mainContent_#{profile_name}_txtStreet").text
        datum.city = person_page.search("td#ctl00_mainContent_#{profile_name}_txtCity").text
        datum.state = person_page.search("td#ctl00_mainContent_#{profile_name}_txtState").text
        datum.zip_code = person_page.search("td#ctl00_mainContent_#{profile_name}_txtZip").text

        datum.inspected = true
      end


      # scrape Scoutlander for the passed adult, popluate their info, and add scout links (but no scout info)
      def fetch_adult_info_with_scout_links(adult_datum)
        adult_page = fetch_adult_info(adult_datum)

        if adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").size > 0
          adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").each do |scout|
            profile = profile_from_url(scout['href'])
            adult_scout = find_or_create_by_profile(profile)
            adult_scout.sl_profile = profile
            adult_scout.sl_url = scout['href']
            adult_scout.sl_uid = uid_from_url(scout['href'])

            if adult_scout.parent.nil?
              adult_datum.add_relation adult_scout
            end
          end
        end
      end


      # goto the adult show page
      def adult_info_page(datum)
        return nil if datum.sl_url.blank?
        login
        @logger.info "ADULT_INFO_PAGE: #{datum.name}, profile: #{datum.sl_profile}, #{datum.sl_url}"
        @agent.get datum.sl_url
      end


      def find_or_create_by_profile(profile)
        @adults.each do |adult|
          return adult if adult.sl_profile == profile
          adult.relations.each do |relation|
            return relation if relation.sl_profile == profile
          end
        end

        Scoutlander::Datum::Person.new
      end


      def fetch_all_adult_info_and_create
        @logger.info "FETCH_ALL_ADULT_INFO_AND_CREATE: start"
        @adults.each do |adult|
          fetch_adult_info(adult)

          begin
            user = @unit.adults.find_or_initialize_by(sl_profile: adult.sl_profile)
            puts user.inspect
            if user.new_record?
              @logger.info "CREATE_USER: #{adult.name}, profile: #{adult.sl_profile}"
              user.update_attributes(adult.to_params)
              @unit.users << user
            else
              @logger.info "UPDATE_USER: #{user.name}"
              user.update_attributes(adult.to_params)
            end

            user.phones.create(kind: 'Home', number: adult.home_phone ) unless adult.home_phone.blank?
            user.phones.create(kind: 'Work', number: adult.work_phone ) unless adult.work_phone.blank?
            user.phones.create(kind: 'Mobile', number: adult.cell_phone ) unless adult.cell_phone.blank?
          rescue ActiveRecord::RecordInvalid
            @logger.error "ActiveRecord::RecordInvalid: #{adult.inspect}"
          end
        end
        @logger.info "FETCH_ALL_ADULT_INFO_AND_CREATE: finish"
      end

    end
  end
end
