class Newsletters < ActionMailer::Base
  default from: "noreply@scoutt.in"

  def events_week(recipient_user_id)
    set_user_units(recipient_user_id)

    mail to: @recipient_user.email,
         subject: "#{units_subject @units} Upcoming Events for the week of "
  end

  def events_month(recipient_user_id)
    set_user_units(recipient_user_id)

    mail to: "to@example.org"
  end


  private
    def set_user_units(recipient_user_id)
      @recipient_user = User.find(recipient_user_id) if recipient_user_id
      @units = @recipient_user.units
    end

    def units_subject(units)
     units.map(&:email_name).join(', ')
    end
end
