module EventReminders
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def send_reminders
      events = Event.needs_reminders
      events.each do |event|
        event.send_reminder
      end
    end


    def needs_reminders
      Event.where(send_reminders: true, reminder_sent_at: nil).where('"events"."start_at" <= ?', 2.days.from_now)
    end
  end




  def send_reminder
    sms_recipients.each { |recipient| TextMessage.delay.event_reminder(self.id, recipient.sms_email_address)}
    if signup_required
      # emails will contain individual links for signup
      # email_recipients.each { |recipient| EventMailer.delay.reminder(self.id, recipient.email, recipient.id) }
    else
      EventMailer.delay.reminder(self.id, recipients_emails)
    end
    # update_attribute(:reminder_sent_at, Time.zone.now)
  end


  def email_recipients
    case kind
    when 'Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event'
      self.unit.users.with_email.gets_email_blast
    when 'Den Event', 'Patrol Event'
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_email_blast }
      sub_unit_users.flatten
    when 'Leader Event'
      self.unit.users.leaders.with_email.gets_email_blast
    end
  end

  def sms_recipients
    case kind
    when 'Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event'
      self.unit.users.with_sms.gets_sms_blast
    when 'Den Event', 'Patrol Event'
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_receiving_sms_blast }
      sub_unit_users.flatten
    when 'Leader Event'
      self.unit.users.leaders.with_sms.gets_sms_blast
    end
  end


  def recipients_emails
    email_recipients.map(&:email)
  end

  def recipients_sms_emails
    sms_recipients.map(&:sms_email_address)
  end


  def email_reminder_subject
    "#{unit.email_name} #{name} - Reminder"
  end

  def sms_reminder_subject
    "#{unit.email_name} #{name.truncate(26, separator: ' ')} - Reminder"
  end

  private

end
