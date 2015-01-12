class MailerBase < ActionMailer::Base
  default from: "noreply@scoutt.in"

  protected
    def set_time_zone(unit)
      @unit = unit
      Time.zone = unit.try(:time_zone) || "Pacific Time (US & Canada)"
    end

end
