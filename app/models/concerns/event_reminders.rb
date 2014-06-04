module EventReminders
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def send_reminders
      Event.needs_reminders.each do |event|
        event.send_reminder
      end
    end


    def needs_reminders
      Event.where(send_reminders: true, reminder_sent_at: nil).where('"events"."start_at" <= ?', 2.days.from_now)
    end
  end




  def send_reminder
    send_sms_reminders
    if signup_required
      # emails will contain individual links for signup
      send_email_reminders
    else
      EventMailer.delay.reminder(self.id, recipients_emails)
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
      self.unit.users.leaders.gets_email_reminder
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
      self.unit.users.leaders.gets_sms_reminder
    end
  end



  def send_sms_reminders
    users_to_sms.each { |recipient| TextMessage.delay.event_reminder(self.id, recipient.sms_email_address) }
  end

  def send_email_reminders
    users_to_email.each { |recipient| EventMailer.delay.reminder(self.id, recipient.email, recipient.id) }
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
