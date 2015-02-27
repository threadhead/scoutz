class MailerBase < ActionMailer::Base
  add_template_helper(EmailEventSignupsHelper)
  add_template_helper(MailerBaseHelper)
  add_template_helper(EventsHelper)
  add_template_helper(UsersHelper)


  default from: "noreply@scoutt.in"

  protected
    def set_time_zone(unit)
      @unit = unit
      Time.zone = unit.try(:time_zone) || "Pacific Time (US & Canada)"
    end

end
