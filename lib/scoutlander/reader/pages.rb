module Scoutlander
  module Reader
    class Pages < Scoutlander::Reader::Base
      attr_reader :pages

      def initialize(options={})
        super(options)
        @pages = []
      end

      def collection
        @pages
      end

      def fetch_page_links
        @logger.info "EXEC(PAGES) : Unit=#{@unit.name}, #{@unit.unit_number}"

        # pages are listed in the left-hand sidbar, and contain CUSTOMID in the URL
        dash_page = login
        unit_page = dash_page.link_with(text: %r{#{@unit.unit_number}}).click
        # puts "unit page uri: #{unit_page.uri}"

        @logger.info 'CLICK : Get Pages Links'
        pages_links = unit_page.links.find_all { |l| l.uri.to_s =~ /CUSTOMID/ }

        pages_links.each do |link|
          page = Scoutlander::Datum::Page.new
          page.title = link.text.lstrip.rstrip
          page.sl_url = (unit_page.uri.merge link.uri)
          @pages << page
        end
      end


      def fetch_all_page_info_and_create
        @logger.info 'FETCH_ALL_PAGE_INFO_AND_CREATE: start'
        @pages.each do |page|
          fetch_page_info(page)

          begin
            unit_page = Page.find_or_initialize_by(unit_id: @unit.id, title: page.title)
            if unit_page.new_record?
              @logger.info "CREATE_PAGE: #{page.title}, url: #{page.sl_url}"
            else
              @logger.info "UPDATE_PAGE: #{page.title}"
            end

            unit_page.update_attributes(page.to_params)

          rescue ActiveRecord::RecordInvalid
            @logger.error "ActiveRecord::RecordInvalid: #{page.inspect}"
          end
        end

        @logger.info 'FETCH_ALL_PAGE_INFO_AND_CREATE: finish'
      end


      def fetch_page_info(datum)
        datum.body = ''

        login
        site_page = @agent.get datum.sl_url
        site_page.encoding = 'utf-8'
        # each pages may contain any number of "bubble" tables (tables styled with a bubble graphic)
        # we are going to combine all those bubble's body into one page

        site_page.search('//td[@id="ctl00_mainContent_PadContainer_PadContainerCell"]/table').each do |pt|
          t = pt.search('.//tr[substring(@id, string-length(@id) -11) = "_secTitleRow"]/td/h2')
          # puts "titlerow: #{t.to_html}"
          datum.body << t.to_html
          c = pt.search('.//div[substring(@id, string-length(@id) -10) = "_lblContent"]')
          # puts c
          datum.body << c.to_html.force_encoding('ASCII-8BIT').force_encoding('UTF-8')
          # page.body << c.to_html.force_encoding("UTF-8")
        end
        datum.inspected = true
      end



    end
  end
end
