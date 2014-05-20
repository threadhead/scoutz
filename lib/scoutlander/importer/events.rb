module Scoutlander
  module Importer
    class Events < Scoutlander::Importer::Base
      attr_accessor :events

      def initialize(options={})
        super(options)
        @events = []
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
          rows.each do |row|
            event = Scoutlander::Datum::Event.new

            event.name = row.children.children[1].text
            event.sl_url = row.children.children[1]['href']
            event.sl_uid = uid_from_url(event.url)
            event.sl_profile = profile_from_url(event.url)

            @events << event
            @logger.info "DATUM::EVENT(created): #{event.name}, #{event.sl_url}"
          end
        end
      end


      def fetch_event_info(datum)
        # this will scrape all the event info except responses
        @logger.info "FETCH_EVENT_INFO: #{datum.name}"
        event_page = event_edit_page(datum)

        datum.kind = sl_kind event_page.search("select#ctl00_mainContent_EventEditProfile_cmbEventType option[@selected='selected']").attr('value').value
        checked_sub_units = event_page.search("input[id^=ctl00_mainContent_EventEditProfile_chklstSubUnit][@checked='checked']").map{|e| e.attr('id')}
        datum.kind_sub_units = checked_sub_units.map{ |su| event_page.search("label[@for='#{su}']").text }

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
      end

      # goto the event show page
      def event_edit_page(datum)
        return nil if datum.url.blank?
        login
        url = "/securesite/calendarmain.aspx?UID=#{@unit.sl_uid}&editprofile=#{datum.sl_profile}"
        @logger.info "EVENT_EDIT_PAGE: #{datum.name}, #{datum.sl_url}"
        @agent.get sl_url
      end

      def event_info_page(datum)
        return nil if datum.url.blank?
        login
        @logger.info "EVENT_INFO_PAGE: #{datum.name}, #{datum.sl_url}"
        @agent.get datum.sl_url
      end

      def scrape_months
        (-2..12).map{ |n| Date.today.beginning_of_month.months_since(n) }
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
