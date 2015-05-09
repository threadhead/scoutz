namespace :event_signups do

  desc 'to new scout/adult individuals'
  task convert: [:environment] do
    logger = Logger.new("#{Rails.root}/log/event_signups_convert_#{Time.now.to_s(:filename)}.log")
    logger.info 'RUNNING'
    logger.info "Total EventSignup rows: #{EventSignup.count}"
    logger.info "EventSignup to be modified (scout_id: nil): #{EventSignup.where.not(scout_id: nil).count}"

    EventSignup.where.not(scout_id: nil).each do |event_signup|
      logger.info "SIGNUP(#{event_signup.id}): scout: #{event_signup.scout.name}(#{event_signup.scout.id})"

      if event_signup.adults_attending > 0 || event_signup.siblings_attending > 0
        adult = event_signup.scout.unit_adults(event_signup.event.unit).first
        logger.info "  transfer adults/siblings to first associated adult: #{adult.name}(#{adult.id})"

        comment = event_signup.adults_attending > 1 ? "Conversion note: #{event_signup.adults_attending} additional adults" : nil

        if adult && event_signup.canceled_at.blank?
          es = EventSignup.create(event_id: event_signup.event.id,
                                  user_id: adult.id,
                                  adults_attending: event_signup.adults_attending,
                                  siblings_attending: event_signup.siblings_attending,
                                  comment: comment
                                 )
          logger.info "  transfered to EventSignup(#{es.id}):, adults_attending: #{es.adults_attending}, siblings_attending: #{es.siblings_attending}"
        end
      end

      event_signup.scouts_attending = 1
      event_signup.adults_attending = 0
      event_signup.siblings_attending = 0
      event_signup.user_id = event_signup.scout_id
      event_signup.scout_id = nil
      saved = event_signup.save
      logger.info "  saved: #{saved}, #{event_signup.inspect}"
    end

    logger.info "Total EventSignup rows: #{EventSignup.count}"
    logger.info 'COMPLETED'
    logger.close
  end

end
