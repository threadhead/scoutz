# This class will crawl a Unit's site on Scoutlander and populate Scoutlander::Datum objects
# with the information it scrapes.


module Scoutlander
  module Importer
    class Scouts < Scoutlander::Importer::Person
      attr_accessor :scout

      def initialize(options={})
        super(options)
        @scouts = []
      end


      def fetch_all_scout_info_and_create
        @logger.info "FETCH_ALL_SCOUT_INFO_AND_CREATE: start"
        @scouts.each do |scout|
          fetch_scout_info(scout)

          begin
            user = @unit.scouts.find_or_initialize_by(sl_profile: scout.sl_profile)
            add_to_sub_unit(user, scout)
            # puts user.inspect
            if user.new_record?
              @logger.info "CREATE_SCOUT: #{scout.name}, profile: #{scout.sl_profile}"
              user.update_attributes(scout.to_params)
              @unit.users << user
            else
              @logger.info "UPDATE_SCOUT: #{user.name}"
              user.update_attributes(scout.to_params)
            end

            create_phones(user, scout)

          rescue ActiveRecord::RecordInvalid
            @logger.error "ActiveRecord::RecordInvalid: #{scout.inspect}"
          end
        end
        @logger.info "FETCH_ALL_SCOUT_INFO_AND_CREATE: finish"
      end



    end
  end
end
