class SmsMessage < ActiveRecord::Base
  include SendToOptions
  include SubUnitIds
  include AttributeSanitizer

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_and_belongs_to_many :users


  validates :message, presence: true

  validate :has_selected_users, if: :send_to_users?
  def has_selected_users
    errors.add(:base, "You must select at least 1 adult or scout recipient") if user_ids.empty?
  end

  sanitize_attributes :message

  def send_to_count
    recipients.blank? ? 0 : recipients.count
  end


  def recipients
    case send_to_option
    when 1
      self.unit.users.gets_sms_message
    when 2
      self.unit.users.leaders.gets_sms_message
    when 3
      # su_users = []
      # sub_units.each { |su| su_users << su.users_receiving_sms_message }
      # su_users.flatten
      sub_units.inject([]) {|users, su| users + su.users_receiving_sms_message }.uniq
    when 4
      self.users.gets_sms_message
    else
      []
    end
  end

  def recipients_emails
    recipients.map(&:sms_email_address).uniq
  end


  def send_sms
    recipients.each { |recipient| TextMessage.delay.sms_message(recipient.sms_email_address, self.id) }
    self.update_attribute(:sent_at, Time.zone.now)
  end

  def self.dj_send_sms(id)
    sm = SmsMessage.find(id)
    sm.send_sms if sm
  end




  #scopes
  scope :by_updated_at, -> { order(updated_at: :desc) }
end
