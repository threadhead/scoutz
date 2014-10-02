class EmailMessage < ActiveRecord::Base
  include SendToOptions
  include SubUnitIds
  include AttributeSanitizer

  serialize :sub_unit_ids, Array

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_many :email_attachments, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :email_attachments, allow_destroy: true

  # attr_accessible :message, :subject, :user_id, :sub_unit_ids, :event_ids, :email_attachments_attributes, :user_ids, :send_to_option

  validates :message, presence: true
  validates :subject, presence: true

  sanitize_attributes :message

  validate :has_selected_users, if: :send_to_users?
  def has_selected_users
    errors.add(:base, "You must select at least 1 adult or scout recipient") if user_ids.empty?
  end

  before_create :ensure_id_token


  def send_email
    if events_have_signup?
      # emails will contain individual links for signup
      recipients.each { |recipient| MessageMailer.delay.email_blast(self.sender.id, recipient.email, self.id, recipient.id) }
    else
      MessageMailer.delay.email_blast(self.sender.id, recipients_emails, self.id)
    end
    self.update_attribute(:sent_at, Time.zone.now)
  end

  def self.dj_send_email(id)
    em = EmailMessage.find(id)
    em.send_email if em
  end



  def has_attachments?
    self.email_attachments.count > 0
  end

  def events_have_signup?
    self.events.where(signup_required: true).count > 0
  end

  def has_events?
    self.events.count > 0
  end


  def send_to_count
    recipients.blank? ? 0 : recipients.count
  end


  def subject_with_unit
    "#{self.unit.email_name} #{subject}"
  end

  def recipients
    case send_to_option
    when 1
      self.unit.users.gets_email_blast
    when 2
      self.unit.users.unit_leaders(self.unit).gets_email_blast
    when 3
      # su_users = []
      # sub_units.each { |su| su_users << su.users_receiving_email_blast }
      # su_users.flatten
      sub_units.inject([]) {|users, su| users + su.users_receiving_email_blast }.uniq
    when 4
      self.users.gets_email_blast
    else
      []
    end
  end

  def recipients_emails
    recipients.map(&:email).uniq
  end



  #scopes
  scope :by_updated_at, -> { order(updated_at: :desc) }

  private

    def ensure_id_token
      self.id_token = valid_token
    end

    def valid_token
      loop do
        rand_token = generate_token
        break rand_token unless EmailMessage.where(id_token: rand_token).first
      end
    end

    def generate_token
      SecureRandom.urlsafe_base64(12) #.tr('+/=lIO0', 'pqrsxyz')
    end

end
