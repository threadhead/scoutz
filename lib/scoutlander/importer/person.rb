module Scoutlander
  module Importer
    class Person < Scoutlander::Importer::Base

      # scrape an adult show page and populate all data
      def fetch_adult_info(datum)
        fetch_person_info(datum, "ParentProfile")
      end

      # scrape a scout show page and populate all data
      def fetch_scout_info(datum)
        fetch_person_info(datum, "ScoutProfile")
      end

      def fetch_person_info(datum, profile_name)
        person_page = person_info_page(datum)
        # person_page = case profile_name
        # when "ParentProfile"
        #   adult_info_page(datum)
        # when "ScoutProfile"
        #   scout_info_page(datum)
        # end
        td_id = "td#ctl00_mainContent_#{profile_name}_"

        datum.leadership_position = person_page.search("#{td_id}txtRole").text
        sl_leadership(datum)
        datum.first_name = person_page.search("#{td_id}txtFirstName").text
        datum.last_name = person_page.search("#{td_id}txtLastName").text
        datum.sub_unit = person_page.search("#{td_id}txtSubUnit").text
        datum.security_level = person_page.search("#{td_id}txtSecurityLevel").text
        datum.email = person_page.search("#{td_id}txtEmail").text
        datum.email = nil if datum.email.downcase == "no email"
        datum.alternate_email = person_page.search("#{td_id}txtAltEmail").text
        datum.send_reminders = person_page.search("#{td_id}txtEventNotification").text.include?("ON")

        datum.home_phone = person_page.search("#{td_id}txtHomePhone").text
        datum.work_phone = person_page.search("#{td_id}txtWorkPhone").text
        datum.cell_phone = person_page.search("#{td_id}txtCellPhone").text

        datum.address1 = person_page.search("#{td_id}txtStreet").text
        datum.city = person_page.search("#{td_id}txtCity").text
        datum.state = person_page.search("#{td_id}txtState").text
        datum.zip_code = person_page.search("#{td_id}txtZip").text

        datum.inspected = true
        person_page
        # puts "datum - fname: #{datum.first_name}, lname: #{datum.last_name}, role: #{person_page.search("#{td_id}txtRole").text}"
      end

      def sl_leadership(datum)
        return if datum.leadership_position.blank?

        roles = datum.leadership_position.split(', ')
        # the first leadership postion may be from a selection option
        # if so, then set leaderhip_postion to that option and additional_leadership_positions to the rest
        if @unit.adult_leadership_positions.include?(roles.first) || @unit.scout_leadership_positions.include?(roles.first)
          datum.leadership_position = roles.first
          roles.delete_at(0)
        end
        datum.additional_leadership_positions = roles.join(', ') unless roles.empty?
      end

      # def get_info_text(page, profile_name, field_id)
      #   page.search("td#ctl00_mainContent_#{profile_name}_#{field_id}").text
      # end

      # goto the adult show page
      def person_info_page(datum)
        return nil if datum.sl_url.blank?
        login
        @logger.info "#{class_name.upcase}_INFO_PAGE: #{datum.name}, profile: #{datum.sl_profile}, #{datum.sl_url}"
        @agent.get datum.sl_url
      end




      def fetch_unit_adults
        fetch_unit_persons(@adults, 'parentmain')
      end

      def fetch_unit_scouts
        fetch_unit_persons(@scouts, 'scoutmain')
      end

      def fetch_unit_persons(datum_collection, profile_name)
        login

        persons_page = @agent.get("/securesite/#{profile_name}.aspx?UID=#{@unit.sl_uid}")
        persons_page.links_with(href: /#{profile_name}.*&profile/).each do |link|
          person = Scoutlander::Datum::Person.new
          person.last_name, person.first_name = link.text.split(', ')
          person.sl_url = link.href
          person.sl_uid = uid_from_url(person.sl_url)
          person.sl_profile = profile_from_url(person.sl_url)
          datum_collection << person
        end
      end





      def create_phones(resource, datum)
        resource.phones.create(kind: 'Home', number: datum.home_phone ) unless datum.home_phone.blank?
        resource.phones.create(kind: 'Work', number: datum.work_phone ) unless datum.work_phone.blank?
        resource.phones.create(kind: 'Mobile', number: datum.cell_phone ) unless datum.cell_phone.blank?
      end

      def add_to_sub_unit(resource, datum)
        sub_unit = @unit.sub_units.where(name: datum.sub_unit).first
        if sub_unit
          resource.sub_unit = sub_unit
        end
      end

    end
  end
end
