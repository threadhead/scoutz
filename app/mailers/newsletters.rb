class Newsletters < ActionMailer::Base
  default from: "noreply@scoutt.in"

  def weekly(unit_id)
    set_unit_recipients(unit_id)
    @events = @unit.events.from_today.where('start_at <= ?', 9.days.from_now.end_of_day).by_start

    mail to: @recipients,
         subject: "#{@unit.email_name} Upcoming Events for the week of "
  end

  def monthly(unit_id)
    set_unit_recipients(unit_id)

    mail to: @recipients,
         subject: "#{@unit.email_name} Upcoming Events for the week of "
  end


  private
    def set_unit_recipients(unit_id)
      @unit = Unit.find(unit_id)
      @recipients = @unit.users.gets_weekly_newsletter.pluck(:email)
    end

end
