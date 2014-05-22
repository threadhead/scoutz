module Scoutlander
  module Saver
    class EventAndSignups
      attr_accessor :event

      def initialize(options={})
        @unit = options[:unit]
        @datum = options[:event]
        @logger = options[:logger] || Logger.new('/dev/null')
        @event = nil
      end

      def create_or_update_event
        begin
          @event = @unit.events.find_or_initialize_by(sl_profile: @datum.sl_profile)

          if @event.new_record?
            @logger.info "CREATE_EVENT: #{@datum.name}, profile: #{@datum.sl_profile}"
          else
            @logger.info "UPDATE_EVENT: #{@datum.name}"
          end

          @event.update_attributes(@datum.to_params)
          create_or_update_event_signups

        rescue ActiveRecord::RecordInvalid
          @logger.error "ActiveRecord::RecordInvalid: #{@datum.inspect}"
        end
      end


      def create_or_update_event_signups

        # delete all the existing signups if there are signups to update
        @event.event_signups.destroy_all unless @datum.event_signups.empty?

        @datum.event_signups.each do |signup|
          if signup.valid?
            scout = Scout.where(sl_profile: signup.sl_profile).first
            @event.event_signups.create(signup.to_params.merge({scout_id: scout.id})) if scout
          end
        end
      end


    end
  end
end
