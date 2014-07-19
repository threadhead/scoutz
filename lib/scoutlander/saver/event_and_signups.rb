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
        if @datum.event_signups.size == 0
          @logger.info "CREATE_EVENT_SIGNUP: #{@datum.name}, no event signups to create"
          return
        else
          @logger.info "CREATE_EVENT_SIGNUP: #{@datum.name}, event_signups: #{@datum.event_signups.size}"
        end
        # we wrap all the creating and updates of signups for two reasons:
        #  - if there is an error creating the signups, we don't want existing signups deleted
        #  - there is a possibiliy of a "bad" signup that would cause deletion of all existing signups, so
        #    we want to make sure that is at least one good signup

        ActiveRecord::Base.transaction do
          # find all the existing signups, to be removed after creation of new signups
          existing_signups = @event.event_signups.pluck(:id)

          at_least_one_signup = false
          @datum.event_signups.each do |signup|
            if signup.valid?
              if scout = Scout.where(sl_profile: signup.sl_profile).first
                @logger.info "CREATE_EVENT_SIGNUP: #{@datum.name}, scout profile: #{signup.sl_profile}, s:#{signup.scouts_attending}, sib:#{signup.siblings_attending}, a:#{signup.adults_attending}"

                # we need to turn off validataions because we ARE going to save duplicates, but later
                #   remove the existing records below. Thus, we will be left with only the new signups
                event_signup = @event.event_signups.build(signup.to_params.merge({scout_id: scout.id}))
                event_signup.save(validate: false)
                at_least_one_signup = true
              else
                @logger.info "CANCELLED EVENT_SIGNUP: scout not found, scout profile: #{@datum.sl_profile}"
              end

            end
          end

          if at_least_one_signup
            @logger.info "REMOVE_EXISTING_EVENT_SIGNUPS: #{@datum.name}, count: #{existing_signups.size}, ids: #{existing_signups}"
            EventSignup.destroy_all(id: existing_signups)
          else
            @logger.info "ROLLBACK - EVENT_SIGNUPS: #{@datum.name}, there was not at least one new signup imported"
           raise ActiveRecord::Rollback
          end

        end
      end


    end
  end
end
