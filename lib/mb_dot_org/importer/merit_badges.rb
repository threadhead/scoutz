# This class will crawl a Unit's site on Scoutlander and populate Scoutlander::Datum objects
# with the information it scrapes.


module MbDotOrg
  module Importer
    class MeritBadges < MbDotOrg::Importer::Base
      attr_accessor :merit_badges

      def initialize(options={})
        super(options)
        @merit_badges = []
      end

      def collection
        @merit_badges
      end

      def fetch_merit_badges
        @agent ||= ::Mechanize.new
        page = @agent.get('http://meritbadge.org/wiki/index.php/Merit_Badge_Worksheets')
        @logger.info "-> GET 'http://meritbadge.org/wiki/index.php/Merit_Badge_Worksheets', status: #{page.code}"

        # the merit badge table of merit badges and workbooks is split into 2 sub-tables
        mb_table_1 = page.search('/html/body/div/div[1]/div/div/table[3]/tr/td[1]/table/tr')[2..-1]
        mb_table_2 = page.search('/html/body/div/div[1]/div/div/table[3]/tr/td[2]/table/tr')[1..-1]
        mb_table = mb_table_1 + mb_table_2

        mb_table.each do |row|
          merit_badge = MbDotOrg::Datum::MeritBadge.new

          first_td = row.children.search('td').first
          merit_badge.name = clean_string first_td.children.at('a')[:title]
          merit_badge.mb_org_url = mb_dot_org_url first_td.children.at('a')[:href]

          row.children.search('td').last.children.search('a').each do |link|
            case link.text
            when "PDF"
              merit_badge.mb_org_worksheet_pdf_url = link[:href]
            when "DOCX"
              merit_badge.mb_org_worksheet_doc_url = link[:href]
            end
          end

          fetch_merit_badge_info_and_create(merit_badge)
          @merit_badges << merit_badge
        end
      end


      def mb_dot_org_url(rel_url)
        "http://meritbadge.org#{rel_url}"
      end

      def fetch_merit_badge_info_and_create(datum)
        fetch_merit_badge_info(datum)

        begin
          merit_badge = MeritBadge.find_or_initialize_by(name: datum.name)
          if merit_badge.new_record?
            @logger.info "  CREATE_MERIT_BADGE: #{datum.name}"
            merit_badge.update_attributes(datum.to_params)
          else
            @logger.info "  UPDATE_MERIT_BADGE: #{datum.name}, merit_badge_id: #{merit_badge.id}"
            merit_badge.update_attributes(datum.to_params)
          end

        rescue ActiveRecord::RecordInvalid
          @logger.error "    ActiveRecord::RecordInvalid: #{merit_badge.inspect}"
        end

      end


      def fetch_merit_badge_info(datum)
        @agent ||= ::Mechanize.new
        page = @agent.get datum.mb_org_url
        @logger.info "  -> GET '#{datum.mb_org_url}', status: #{page.code}"

        datum.patch_image_url = mb_dot_org_url page.search('td[rowspan="7"] a img').first[:src]
        page.search('/html/body/div/div[1]/div/div/table/tr').each do |row|
          td = row.search('td')
          case clean_string(td[0].text).downcase
          when "status:"
            datum.eagle_required = clean_string(td[1].text)
            mb_eagle_required(datum)
          when "created:"
            datum.year_created = clean_string(td[1].text)
          when "bsa advancement id:"
            datum.bsa_advancement_id = clean_string(td[1].text)
          end
        end
        datum.inspected = true
      end

      def mb_eagle_required(datum)
        datum.eagle_required = !(datum.eagle_required.downcase =~ /elective/)
      end

    end
  end
end
