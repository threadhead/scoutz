class Newsletters < ActionMailer::Base
  default from: "noreply@scoutt.in"

  def weekly(unit)
    set_time_zone(unit)
    @recipients = @unit.users.gets_weekly_newsletter.pluck(:email)
    @events = @unit.events.newsletter_next_week.by_start
    @subject = "Upcoming Events for the week of #{Time.zone.now.next_week.to_s(:draft_date)}"

    mail to: @recipients,
         subject: "#{@unit.email_name} #{@subject}"
  end

  def monthly(unit)
    set_time_zone(unit)
    @recipients = @unit.users.gets_monthly_newsletter.pluck(:email)
    @events = @unit.events.newsletter_next_month.by_start
    @subject = "Upcoming Events for the month of #{Time.zone.now.next_month.strftime('%B %Y')}"

    mail to: @recipients,
         subject: "#{@unit.email_name} #{@subject}",
         template_name: 'weekly'
  end


  private
    def set_time_zone(unit)
      @unit = unit
      Time.zone = unit.time_zone || "Pacific Time (US & Canada)"
    end

end
