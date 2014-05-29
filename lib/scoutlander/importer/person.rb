module Scoutlander
  module Importer
    class Person < Scoutlander::Importer::Base

      def profile_name(kind)
        case kind
        when :scout
          'ScoutProfile'
        when :adult
          'ParentProfile'
        end
      end

      def fetch_person_info(kind, datum)
        person_page = person_info_page(datum)
        reader = Scoutlander::Importer::TdReader.new(page: person_page, id: "td#ctl00_mainContent_#{profile_name(kind)}_")

        {
          leadership_position: 'txtRole',
          first_name: 'txtFirstName',
          last_name: 'txtLastName',
          sub_unit: 'txtSubUnit',
          rank: 'txtRank',
          security_level: 'txtSecurityLevel',
          email: 'txtEmail',
          alternate_email: 'txtAltEmail',
          send_reminders: 'txtEventNotification',
          home_phone: 'txtHomePhone',
          work_phone: 'txtWorkPhone',
          cell_phone: 'txtCellPhone',
          address1: 'txtStreet',
          city: 'txtCity',
          state: 'txtState',
          zip_code: 'txtZip'
        }.each do |k,v|
          datum.send("#{k}=".to_sym, reader.get_text_with(v))
        end

        # massage some of the data
        sl_leadership(datum)
        datum.email = nil if datum.email.nil? || datum.email.downcase == "no email"
        datum.send_reminders = !datum.send_reminders.nil? && datum.send_reminders.include?("ON")

        datum.inspected = true
        person_page
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


      # goto the person's show page
      def person_info_page(datum)
        return nil if datum.sl_url.blank?
        login
        @logger.info "#{class_name.upcase}_INFO_PAGE: #{datum.name}, profile: #{datum.sl_profile}, #{datum.sl_url}"
        @agent.get datum.sl_url
      end



      def unit_profile_name(kind)
        case kind
        when :adult
          'parentmain'
        when :scout
          'scoutmain'
        end
      end

      def fetch_unit_persons(kind)
        login

        persons_page = @agent.get("/securesite/#{unit_profile_name(kind)}.aspx?UID=#{@unit.sl_uid}")
        persons_page.links_with(href: /#{unit_profile_name(kind)}.*&profile/).each do |link|
          person = Scoutlander::Datum::Person.new
          person.last_name, person.first_name = link.text.split(', ')
          person.sl_url = link.href
          person.sl_uid = uid_from_url(person.sl_url)
          person.sl_profile = profile_from_url(person.sl_url)
          collection << person     # collection is defined in subclasses
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
