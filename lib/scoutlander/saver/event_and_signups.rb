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
          create_or_update_sub_units
          create_or_update_event_signups

        rescue ActiveRecord::RecordInvalid
          @logger.error "ActiveRecord::RecordInvalid: #{@datum.inspect}"
        end
      end


      def create_or_update_sub_units
        if @event.sub_unit_kind?
          @datum.kind_sub_units.each do |sub_unit|
            event_sub_unit = @event.sub_units.where(name: sub_unit).first
            if event_sub_unit.nil?
              su = @unit.sub_units.where(name: sub_unit).first
              @event.sub_units << su if su
            end
          end
        end
      end


      def create_or_update_event_signups
        # we wrap all the creating and updates of signups for two reasons:
        #  - if there is an error creating the signups, we don't want existing signups deleted
        #  - there is a possibiliy of a "bad" signup that would cause deletion of all existing signups, so
        #    we want to make sure that is at least one good signup

        ActiveRecord::Base.transaction do
          # find all the existing signups, to be removed after creation of new signups
          existing_signups = @event.event_signups.all.load

          at_least_one_signup = false
          @datum.event_signups.each do |signup|
            if signup.valid?
              scout = Scout.where(sl_profile: signup.sl_profile).first
              if scout
                @event.event_signups.create(signup.to_params.merge({scout_id: scout.id}))
                @logger.info "CREATE_EVENT_SIGNUP: #{@datum.name}, scout profile: #{signup.sl_profile}, s:#{signup.scouts_attending}, sib:#{signup.siblings_attending}, a:#{signup.adults_attending}"

              else
                @logger.info "CANCELLED EVENT_SIGNUP: scout not found, #{@datum.name}, profile: #{@datum.sl_profile}"
              end

              at_least_one_signup = true
            end
          end

          if at_least_one_signup
            @logger.info "REMOVE_EXISTING_EVENT_SIGNUPS: #{@datum.name}, count: #{existing_signups.size}"
            existing_signups.destroy_all
          else
            @logger.info "ROLLBACK - EVENT_SIGNUPS: #{@datum.name}, there was not at least one new signup imported"
           raise ActiveRecord::Rollback
          end

        end
      end


    end
  end
end
