class EmailMessage < ActiveRecord::Base
  serialize :sub_unit_ids

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_many :email_attachments, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :email_attachments, allow_destroy: true

  # attr_accessible :message, :subject, :user_id, :sub_unit_ids, :event_ids, :email_attachments_attributes, :user_ids, :send_to_option

  validates :message, presence: true
  validates :subject, presence: true

  validate :has_selected_sub_units, if: :send_to_sub_units?
  def has_selected_sub_units
    errors.add(:base, "You must select at least 1 #{self.unit.try(:sub_unit_name)}") if sub_unit_ids.empty?
  end

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

  # the default: Array.new for serialized columns does not work
  # this is the workaround
  def sub_unit_ids
    value = super
    if value.is_a?(Array)
      value
    else
      self.sub_unit_ids = Array.new
    end
  end

  def send_to(to_unit=self.unit)
    case send_to_option
    when 1
      "Everyone in #{to_unit.name}"
    when 2
      "All #{to_unit.name} Leaders"
    when 3
      "Selected #{to_unit.sub_unit_name.pluralize}"
    when 4
      "Selected Adults/Scouts"
    end
  end

  def has_attachments?
    self.email_attachments.count > 0
  end

  def events_have_signup?
    self.events.where(signup_required: true).size > 0
  end

  def has_events?
    self.events.size > 0
  end


  def send_to_count
    recipients ? recipients.count : 0
  end


  def subject_with_unit
    "#{self.unit.email_name} #{subject}"
  end

  def recipients
    case send_to_option
    when 1
      self.unit.users.with_email
    when 2
      self.unit.users.leaders.with_email
    when 3
      su_users = []
      sub_units.each { |su| su_users << su.users_with_emails }
      su_users.flatten
      # Scout.with_email.joins(:sub_unit).where(sub_units: {id: sub_unit_ids}) +
      # Adult.with_email.joins(:sub_unit).where(sub_units: {id: sub_unit_ids})
    when 4
      self.users.with_email
    else
      []
    end
  end

  def recipients_emails
    recipients.map(&:email)
  end

  def sub_units
    SubUnit.where(id: sub_unit_ids)
  end

  def send_to_unit?
    send_to_option == 1
  end

  def send_to_leaders?
    send_to_option == 2
  end

  def send_to_sub_units?
    send_to_option == 3
  end

  def send_to_users?
    send_to_option == 4
  end


  def self.send_to_options(unit)
    [
      ["Everyone in #{unit.name}", 1],
      ["#{unit.name} Leaders", 2],
      ["Selected #{unit.sub_unit_name.pluralize}", 3],
      ["Selected Adults/Scouts", 4]
    ]
  end

  before_save :sanitize_message
  def sanitize_message
    self.message = Sanitize.clean(message, whitelist)
  end



  #scopes
  def self.by_updated_at
    order('"email_messages"."updated_at" DESC')
  end

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

    def whitelist
      whitelist = Sanitize::Config::RELAXED
      whitelist[:elements] << "span"
      whitelist[:attributes]["span"] = ["style"]
      whitelist
    end
end
