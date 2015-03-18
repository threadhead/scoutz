namespace :event_signups do

  desc "to new scout/adult individuals"
  task convert: [:environment] do
    EventSignup.where.not(scout_id: nil).each do |event_signup|

      if event_signup.adults_attending > 0 || event_signup.siblings_attending > 0
        adult = event_signup.scout.unit_adults(event_signup.event.unit).first
        if adult && event_signup.canceled_at.blank?
          EventSignup.create( event_id: event_signup.event.id,
                              user_id: adult.id,
                              adults_attending: event_signup.adults_attending,
                              siblings_attending: event_signup.siblings_attending
                              )
        end
      end

      event_signup.adults_attending = 0
      event_signup.siblings_attending = 0
      event_signup.user_id = event_signup.scout_id
      event_signup.scout_id = nil
      event_signup.save
    end
  end

end
