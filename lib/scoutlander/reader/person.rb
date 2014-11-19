module Scoutlander
  module Reader
    class Person < Scoutlander::Reader::Base

      def initialize(options={})
        super(options)
        @disable_all_notifications = options[:disable_all_notifications] || false
      end


      def disable_all_notifications(user)
        if @disable_all_notifications
          user.turn_off_all_notifications!
        end
      end

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
        reader = Scoutlander::Reader::TdReader.new(page: person_page, id: "td#ctl00_mainContent_#{profile_name(kind)}_")

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
        sl_rank(datum)
        sl_leadership(datum)
        sl_role(datum)
        datum.email = nil if datum.email.nil? || datum.email.downcase == "no email"
        datum.send_reminders = !datum.send_reminders.nil? && datum.send_reminders.include?("ON")

        datum.inspected = true
        person_page
      end

      def sl_rank(datum)
        return if datum.rank.blank?
        datum.rank.gsub!(/ Rank/, '')
      end

      def sl_leadership(datum)
        return if datum.leadership_position.blank?

        roles = datum.leadership_position.split(', ')
        # the first leadership position may be from a selection option
        # if so, then set leaderhip_position to that option and additional_leadership_positions to the rest
        if @unit.adult_leadership_positions.include?(roles.first) || @unit.scout_leadership_positions.include?(roles.first)
          datum.leadership_position = roles.first
          roles.delete_at(0)
        end
        datum.additional_leadership_positions = roles.join(', ') unless roles.empty?
      end

      def sl_role(datum)
        datum.role = case datum.security_level.downcase
        when /leader access/
          'leader'
        when /admin access/
          'admin'
        else
          'basic'
        end
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
        resource.phones.create(kind: 'home', number: datum.home_phone ) unless datum.home_phone.blank?
        resource.phones.create(kind: 'work', number: datum.work_phone ) unless datum.work_phone.blank?
        resource.phones.create(kind: 'mobile', number: datum.cell_phone ) unless datum.cell_phone.blank?
      end

      def add_to_sub_unit(resource, datum)
        sub_unit = @unit.sub_units.where(name: datum.sub_unit).first
        if sub_unit
          resource.sub_unit = sub_unit
        end
      end

      def add_user_to_unit(user)
        if @unit.users.where(id: user.id).exists?
          @logger.info "LINK USER TO UNIT: link exists"
        else
          @logger.info "LINK USER TO UNIT: user_id: #{user.id}, unit_id: #{@unit.id}"
          @unit.users << user
        end
      end

      def add_unit_positions(resource, datum)
        unit_position = UnitPosition.find_or_initialize_by(unit_id: @unit.id, user_id: resource.id)
        unit_position.update_attributes(leadership: datum.leadership_position, additional: datum.additional_leadership_positions)
      end

    end
  end
end
