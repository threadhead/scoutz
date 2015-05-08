module Scoutlander
  module Reader
    class Events < Scoutlander::Reader::Base
      attr_accessor :events

      def initialize(options={})
        super(options)
        @events = []
      end

      def collection
        @events
      end


      def fetch_unit_events
        @logger.info "EXEC(EVENTS) : Unit=#{@unit.name}, #{@unit.unit_number}"
        return if @unit.blank?

        login

        events_page = nil
        scrape_months.each do |month|
          url = "/securesite/calendarmain.aspx?UID=#{@unit.sl_uid}&CAL=#{month.strftime("%-m/%-d/%Y")}"
          @logger.info "FETCH_UNIT_EVENTS(url): #{url}"
          events_page = @agent.get url
          rows = events_page.search('table#ctl00_mainContent_CalendarView_EventListView_tblEventList tr')[2..-1]
          if rows
            rows.each do |row|
              event = Scoutlander::Datum::Event.new

              event.name = row.children.children[1].text
              event.sl_url = row.children.children[1]['href']
              event.sl_uid = uid_from_url(event.sl_url)
              event.sl_profile = profile_from_url(event.sl_url)

              @events << event
              @logger.info "DATUM::EVENT(created): #{event.name}, #{event.sl_url}"
            end
          end
        end
      end



      def fetch_all_event_info_and_create
        @logger.info "FETCH_ALL_EVENT_INFO_AND_CREATE: start"
        @events.each do |event|
          fetch_event_info(event)
          saver = Scoutlander::Saver::EventAndSignups.new(unit: @unit, event: event, logger: @logger)
          saver.create_or_update_event
        end
        @logger.info "FETCH_ALL_EVENT_INFO_AND_CREATE: finish"
      end




      def fetch_event_info(datum)
        event_page = event_info_page(datum)
        td_id = "td#ctl00_mainContent_EventProfile_"

        datum.kind = event_page.search("#{td_id}txtEventType").text
        datum.kind_sub_units = event_page.search("#{td_id}txtSubUnit").text
        sub_units_parse(datum)

        datum.name = event_page.search("#{td_id}txtEventName").text
        organizer_name = event_page.search("#{td_id}txtOrganizer").text
        datum.organizer_user = find_organizer(organizer_name)
        datum.send_reminders = !!(event_page.search("#{td_id}txtEventReminders").text =~ /ON/)

        start_at = event_page.search("#{td_id}txtStartDT").text
        datum.start_at = up_to_dash(start_at).in_time_zone(@unit.time_zone)
        end_at = event_page.search("#{td_id}txtEndDT").text
        datum.end_at = up_to_dash(end_at).in_time_zone(@unit.time_zone)

        datum.signup_required = event_page.search("#{td_id}txtDeadline").text
        signup_and_deadline(datum)

        datum.location_name = event_page.search("#{td_id}txtLocationName").text
        datum.location_address1 = event_page.search("#{td_id}txtStreetAddress").text
        datum.location_city = event_page.search("#{td_id}txtCity").text
        datum.location_state = event_page.search("#{td_id}txtState").text
        datum.location_zip_code = event_page.search("#{td_id}txtZipCode").text
        datum.location_map_url = event_page.links_with(id: "ctl00_mainContent_EventProfile_lnkLocationMapURL")
        datum.location_map_url = datum.location_map_url.empty? ? nil : datum.location_map_url.first.href

        datum.attire = event_page.search("#{td_id}txtAttire").text
        datum.attire = sl_attire(datum.attire[0])

        datum.message = event_page.search("#{td_id}txtMessage").children.to_s
        datum.fees = event_page.search("#{td_id}txtFees").text

        t = event_page.search("table#ctl00_mainContent_EventProfile_EventScoutParticipants_tblParticipants>tr")
        t.each do |row|
          event_signup = Scoutlander::Datum::EventSignup.new
          event_signup.sl_profile = find_response_link_profile(row)
          find_response_amounts(row, event_signup)
          event_signup.comment = clean_string row.at('td[5]').try(:text)
          event_signup.inspected = true

          datum.add_signup event_signup
        end
        # pp datum.kind
        # pp datum.kind_sub_units

        # event_page.at("table#ctl00_mainContent_EventProfile_EventScoutParticipants_tblParticipants").each do |row|
        #   puts event_signup.sl_profile.inspect
        # end

      end


      def find_response_amounts(row, datum)
        datum.scouts_attending = response_value row, 'Scout'
        datum.siblings_attending = response_value row, 'Sibling'
        datum.adults_attending = response_value row, 'Adult'
      end

      def response_value(row, attending)
        td = row.search('td table tr').at("td:contains('#{attending}')")
        return 0 if td.nil?
        td.next.text.to_i
      end

      def find_response_link_profile(row)
        r = row.at('a')
        return if r.blank?
        link_js = r.attr('onclick').to_s
        link_js.split(';').first.gsub(/[^\d]/, '')
      end

      def signup_and_deadline(datum)
        if datum.signup_required.downcase == "no signup required"
          datum.signup_required = false
          datum.signup_deadline = nil
        else
          datum.signup_deadline = up_to_dash(datum.signup_required).in_time_zone(@unit.time_zone)
          datum.signup_required = true
        end
      end

      def up_to_dash(str)
        clean_string str.split('-').first
      end

      def sub_units_parse(datum)
        datum.kind_sub_units = if datum.kind == 'Patrol Event' || datum.kind == 'Den Event'
          return [] if datum.kind_sub_units.blank?
          datum.kind_sub_units.strip.split(']').map {|v| clean_string v.sub('[','')}
        else
          []
        end
      end

      def find_organizer(name)
        l_name, f_name = clean_string(name).split(', ')
        organizer = @unit.adults.where(first_name: f_name, last_name: l_name).first
        if organizer.blank?
          organizer = @unit.scouts.where(first_name: f_name, last_name: l_name).first
        end
        organizer
      end


      def fetch_event_edit_info(datum)
        # this will scrape all the event info except responses
        @logger.info "FETCH_EVENT_INFO: #{datum.name}"
        event_page = event_edit_page(datum)

        datum.kind = sl_kind event_page.search("select#ctl00_mainContent_EventEditProfile_cmbEventType option[@selected='selected']").attr('value').value
        checked_sub_units = event_page.search("input[id^=ctl00_mainContent_EventEditProfile_chklstSubUnit][@checked='checked']").map {|e| e.attr('id')}
        datum.kind_sub_units = checked_sub_units.map { |su| event_page.search("label[@for='#{su}']").text }

        datum.name = event_page.search("input#ctl00_mainContent_EventEditProfile_txtEventName").attr('value').value
        datum.organizer_profile = event_page.search("select#ctl00_mainContent_EventEditProfile_cmbOrganizer option[@selected='selected']").attr('value').value
        datum.send_reminders = !!event_page.search("input#ctl00_mainContent_EventEditProfile_rdoERON").attr('checked')

        datum.start_at = sl_time_to_datetime event_page.search("input#ctl00_mainContent_EventEditProfile_capStartDT_Picker_selecteddates").attr('value').value
        datum.end_at = sl_time_to_datetime event_page.search("input#ctl00_mainContent_EventEditProfile_capEndDT_Picker_selecteddates").attr('value').value

        datum.signup_required = event_page.search("select#ctl00_mainContent_EventEditProfile_cmbRSVP option[@selected='selected']").attr('value').value == '1'
        datum.signup_deadline = sl_time_to_datetime event_page.search("input#ctl00_mainContent_EventEditProfile_capDeadLineDT_Picker_selecteddates").attr('value').value

        datum.location_name = event_page.search("input#ctl00_mainContent_EventEditProfile_txtLocationName").attr('value').value
        datum.location_address1 = event_page.search("input#ctl00_mainContent_EventEditProfile_txtStreetAddress").attr('value').value
        datum.location_city = event_page.search("input#ctl00_mainContent_EventEditProfile_txtCity").attr('value').value
        datum.location_state = event_page.search("input#ctl00_mainContent_EventEditProfile_txtState").attr('value').value
        datum.location_zip_code = event_page.search("input#ctl00_mainContent_EventEditProfile_txtZipCode").attr('value').value
        datum.location_url = event_page.search("input#ctl00_mainContent_EventEditProfile_txtLocationMapURL").attr('value').value

        datum.attire = sl_attire event_page.search("select#ctl00_mainContent_EventEditProfile_cmbAttire option[@selected='selected']").attr('value').value
        datum.message = CGI::unescape event_page.search("textarea#ctl00_mainContent_EventEditProfile_Editor1ContentHiddenTextarea").text
        datum.fees = event_page.search("textarea#ctl00_mainContent_EventEditProfile_txtFees").children.text

        datum.inspected = true
      end



      # goto the event show page
      def event_edit_page(datum)
        return nil if datum.sl_profile.blank?
        login
        url = "/securesite/calendarmain.aspx?UID=#{@unit.sl_uid}&editprofile=#{datum.sl_profile}"
        @logger.info "EVENT_EDIT_PAGE: #{datum.name}, #{url}"
        @agent.get url
      end

      def event_info_page(datum)
        return nil if datum.sl_url.blank?
        login
        @logger.info "EVENT_INFO_PAGE: #{datum.name}, #{datum.sl_url}"
        @agent.get datum.sl_url
      end



      def scrape_months
        (-2..12).map { |n| Date.today.beginning_of_month.months_since(n) }
      end


      def sl_time_to_datetime(str)
        return nil if str.blank?
        v = str.split('.')
        DateTime.new(v[0].to_i, v[1].to_i, v[2].to_i, v[3].to_i, v[4].to_i, v[5].to_i, v[6].to_i)
      end

      def sl_attire(str)
        case str
        when '0'
          'No Uniform, Comfortable Clothing'
        when '1'
          'Activity Uniform (Class B)'
        when '2'
          'Field or Activity Uniform'
        when '3'
          'Field Uniform (Class A)'
        else
          'Field Uniform (Class A)'
        end
      end

      def sl_kind(str)
        @unit.event_kinds[str.to_i]
      end


    end
  end
end
