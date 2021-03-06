require 'logger'

module EventReminders
  extend ActiveSupport::Concern

  # included do
  # end

  class_methods do
    def reminder_logger
      @@event_reminder_logger ||= Logger.new(File.join(Rails.root, 'log', 'event_reminders.log'))
    end



    def needs_reminders
      # reminders that are at least 2 days away, have not had a rminder already sent, and are not past the end time
      Event.where(send_reminders: true, reminder_sent_at: nil).
            where('"events"."start_at" <= ?', 2.days.from_now).
            where('"events"."end_at" > ?', Time.zone.now)
    end
  end




  def send_reminder
    self.class.reminder_logger.info "  Reminders for (#{self.id}): #{self.name}"
    send_sms_reminders
    send_email_reminders
    update_column(:reminder_sent_at, Time.zone.now)
  end



  def send_sms_reminders
    self.class.reminder_logger.info "    Sending SMS reminders to: #{recipients_sms_emails.join(', ')}"
    users_to_sms.each { |recipient| TextMessage.event_reminder(self, recipient.sms_email_address).deliver_later }
  end

  def send_email_reminders
    self.class.reminder_logger.info "    Sending email reminders to: #{recipients_emails.join(', ')}"
    users_to_email.each do |user|
      EventMailer.reminder(self, user).deliver_later
    end
  end





  def users_to_email
    if unit_meeting_event_camping_plc_kind?
      self.unit.users.gets_email_reminder
    elsif sub_unit_kind?
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_email_reminder }
      sub_unit_users.flatten
    elsif adult_leader_kind?
      self.unit.users.unit_leaders(self.unit).gets_email_reminder
    else
      []
    end
  end

  def users_to_sms
    if unit_meeting_event_camping_plc_kind?
      self.unit.users.gets_sms_reminder
    elsif sub_unit_kind?
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_sms_reminder }
      sub_unit_users.flatten
    elsif adult_leader_kind?
      self.unit.users.unit_leaders(self.unit).gets_sms_reminder
    else
      []
    end
  end






  def recipients_emails
    users_to_email.map(&:email)
  end

  def recipients_sms_emails
    users_to_sms.map(&:sms_email_address)
  end


  def email_reminder_subject
    "#{name} - Reminder #{unit.email_name}"
  end

  def sms_reminder_subject
    "#{name.truncate(26, separator: ' ')} - Reminder"
  end

end
