require 'logger'

module EventReminders
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def reminder_logger
      @@event_reminder_logger ||= Logger.new(File.join(Rails.root, 'log', 'event_reminders.log'))
    end

    # MOVED TO ACTIVERJOB - EventRemindersJob
    # def send_reminders
    #   events = Event.needs_reminders
    #   Event.reminder_logger.info "#{events.size} events need reminders"
    #   events.each do |event|
    #     event.send_reminder
    #   end
    # end


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
    if signup_required
      # emails will contain individual links for signup
      send_email_reminders
    else
      self.class.reminder_logger.info "    Sending email (group) reminders to: #{recipients_emails.join(', ')}"
      EventMailer.reminder(self, recipients_emails, nil).deliver_later
    end
    update_attribute(:reminder_sent_at, Time.zone.now)
  end



  def users_to_email
    case kind
    when 'Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event'
      self.unit.users.gets_email_reminder
    when 'Den Event', 'Patrol Event'
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_email_reminder }
      sub_unit_users.flatten
    when 'Leader Event'
      self.unit.users.unit_leaders(self.unit).gets_email_reminder
    end
  end

  def users_to_sms
    case kind
    when 'Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event'
      self.unit.users.gets_sms_reminder
    when 'Den Event', 'Patrol Event'
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_sms_reminder }
      sub_unit_users.flatten
    when 'Leader Event'
      self.unit.users.unit_leaders(self.unit).gets_sms_reminder
    end
  end



  def send_sms_reminders
    self.class.reminder_logger.info "    Sending SMS reminders to: #{recipients_sms_emails.join(', ')}"
    users_to_sms.each { |recipient| TextMessage.event_reminder(self, recipient.sms_email_address).deliver_later }
  end

  def send_email_reminders
    self.class.reminder_logger.info "    Sending email (individual) reminders to: #{recipients_emails.join(', ')}"
    users_to_email.each { |recipient| EventMailer.reminder(self, recipient.email, recipient).deliver_later }
  end




  def recipients_emails
    users_to_email.map(&:email)
  end

  def recipients_sms_emails
    users_to_sms.map(&:sms_email_address)
  end


  def email_reminder_subject
    "#{unit.email_name} #{name} - Reminder"
  end

  def sms_reminder_subject
    "#{unit.email_name} #{name.truncate(26, separator: ' ')} - Reminder"
  end

end
