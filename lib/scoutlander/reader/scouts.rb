# This class will crawl a Unit's site on Scoutlander and populate Scoutlander::Datum objects
# with the information it scrapes.


module Scoutlander
  module Reader
    class Scouts < Scoutlander::Reader::Person
      attr_accessor :scouts

      def initialize(options={})
        super(options)
        @scouts = []
      end

      def collection
        @scouts
      end

      def fetch_unit_scouts
        fetch_unit_persons(:scout)
      end

      def fetch_scout_info(datum)
        fetch_person_info(:scout, datum)
      end


      def fetch_all_scout_info_and_create
        @logger.info "FETCH_ALL_SCOUT_INFO_AND_CREATE: start"
        @scouts.each do |scout|
          fetch_scout_info(scout)

          begin
            user = Scout.find_or_initialize_by(sl_profile: scout.sl_profile)
            add_to_sub_unit(user, scout)
            # puts user.inspect
            if user.new_record?
              @logger.info "CREATE_SCOUT: #{scout.name}, profile: #{scout.sl_profile}"
            else
              @logger.info "UPDATE_SCOUT: #{user.name}"
            end

            user.update_attributes(scout.to_params)
            disable_all_notifications(user)
            add_user_to_unit(user)
            add_unit_positions(user, scout)
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
