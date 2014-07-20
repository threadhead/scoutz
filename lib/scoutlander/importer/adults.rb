# This class will crawl a Unit's site on Scoutlander and populate Scoutlander::Datum objects
# with the information it scrapes.


module Scoutlander
  module Importer
    class Adults < Scoutlander::Importer::Person
      attr_accessor :adults

      def initialize(options={})
        super(options)
        @adults = []
      end

      def collection
        @adults
      end

      def fetch_unit_adults
        fetch_unit_persons(:adult)
      end

      def fetch_adult_info(datum)
        fetch_person_info(:adult, datum)
      end

      # in general, you would first scrape the 'Adult Search' table using .fetch_unit_adults
      #  this will poplulate the @adults array with basid name, uid (user id), and url (used to get details)

      #  after the @adults are populated, you can use .fetch_adult_info_with_scout_links to get the detail
      #  info for each adult. this will also created related scouts (with uid and url) for each adult


      # just scrape for unit audults (name and profile id/href), no scout info





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
      end




      # scrape Scoutlander for the passed adult, popluate their info, and add scout links (but no scout info)
      def fetch_adult_info_with_scout_links(adult_datum)
        adult_page = fetch_person_info(:adult, adult_datum)

        if adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").size > 0
          adult_page.search("table#ctl00_mainContent_ParentProfile_tblScoutGrid a").each do |scout|
            profile = profile_from_url(scout['href'])
            # adult_scout = find_or_create_by_profile(profile)
            related_scout = Scoutlander::Datum::Person.new
            related_scout.sl_profile = profile
            related_scout.sl_url = scout['href']
            related_scout.sl_uid = uid_from_url(scout['href'])

            adult_datum.add_relation related_scout
            # if related_scout.parent.nil?
            #   adult_datum.add_relation related_scout
            # end
          end
        end
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
          fetch_adult_info_with_scout_links(adult)

          begin
            user = Adult.find_or_initialize_by(sl_profile: adult.sl_profile)
            if user.new_record?
              @logger.info "CREATE_ADULT: #{adult.name}, profile: #{adult.sl_profile}"
            else
              @logger.info "UPDATE_ADULT: #{user.name}"
            end

            user.update_attributes(adult.to_params)
            disable_all_notifications(user)
            add_user_to_unit(user)
            create_phones(user, adult)
            find_and_associate_scout(user, adult)

          rescue ActiveRecord::RecordInvalid
            @logger.error "ActiveRecord::RecordInvalid: #{adult.inspect}"
          end
        end
        @logger.info "FETCH_ALL_ADULT_INFO_AND_CREATE: finish"
      end



      # We are counting on the importing of Scouts to be done first.
      def find_and_associate_scout(resource, adult)
        # puts "adult: #{adult.inspect}"
        adult.relations.each do |scout|
          rel_user = resource.scouts.where(sl_profile: scout.sl_profile).first

          # if the adult(user) -> scout relationship does not exist, create it
          if rel_user.nil?
            related = Scout.where(sl_profile: scout.sl_profile).first
            resource.scouts << related if related
          end
        end

      end

    end
  end
end
