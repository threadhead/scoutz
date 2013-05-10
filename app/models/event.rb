class Event < ActiveRecord::Base
  belongs_to :unit
  has_many :event_signups, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :sub_units
  # acts_as_gmappable process_geocoding: false, validation: false

  attr_accessible :attire, :end_at, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :unit_id, :send_reminders, :signup_deadline, :signup_required, :start_at, :user_ids, :message, :sub_unit_ids

  validates_presence_of :name
  validates_presence_of :start_at
  validates_presence_of :end_at

  validate :validate_start_at_before_end_at
  def validate_start_at_before_end_at
    if end_at && start_at
      errors.add(:end_at, "must be after the start time") if end_at <= start_at
    end
  end


  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.location_address1}, #{self.location_city}, #{self.location_state}"
  end

  def sub_unit_kind?
    self.kind =~ /Den|Patrol/
  end

  before_create :ensure_signup_token

  before_save :sanitize_message
  def sanitize_message
    self.message = Sanitize.clean(message, Sanitize::Config::RELAXED)
  end

  after_save :update_attendee_count
  def update_attendee_count
    self.update_column(:attendee_count, event_signup_count)
  end

  def event_signup_count
    EventSignup.find_by_sql([
          "SELECT
           SUM(\"event_signups\".\"scouts_attending\") +
           SUM(\"event_signups\".\"adults_attending\") +
           SUM(\"event_signups\".\"siblings_attending\")
           AS sum_id
           FROM \"event_signups\"
           WHERE \"event_signups\".\"event_id\" = ?", self.id]).first.try(:sum_id) || 0
  end

  def full_address
    "#{location_address1} #{}"
  end

  def after_signup_deadline?
    signup_deadline <= Time.zone.now
  end

  def user_signups(user)
    user.unit_scouts(self.unit).map do |scout|
      self.event_signups.where(scout_id: scout.id).first || EventSignup.new(scout_id: scout.id)
    end
  end

  def event_signup_users
    scout_ids = self.event_signups.select('"event_signups"."scout_id"').map(&:scout_id)
    scouts_with_email = Scout.where(id: scout_ids).with_email
    adults_with_email = Adult.uniq.with_email.joins(:scouts).where(user_relationships: {scout_id: scout_ids})
    scouts_with_email + adults_with_email
  end

  def event_signup_user_ids
    event_signup_users.map(&:id)
  end

  def self.send_reminders
    events = Event.need_reminders
    events.each do |event|
      event.send_reminder
    end
  end

  def self.need_reminders
    Event.where(send_reminders: true, reminder_sent_at: nil).where('"events"."end_at" <= ?', 2.days.from_now)
  end

  def send_reminder
    if signup_required
      # emails will contain individual links for signup
      recipients.each { |recipient| EventMailer.reminder(self, recipient.email, recipient).deliver }
    else
      EventMailer.reminder(self, recipients_emails).deliver
    end
    # update_attribute(:reminder_sent_at, Time.zone.now)
  end

  def recipients
    case kind
    when 'Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event'
      self.unit.users.with_email
    when 'Den Event', 'Patrol Event'
      sub_unit_users = []
      self.sub_units.each { |su| sub_unit_users << su.users_with_emails }
      sub_unit_users.flatten
    when 'Leader Event'
      self.unit.users.leaders.with_email
    end
  end

  def recipients_emails
    recipients.map(&:email)
  end

  def reminder_subject
    "#{unit.email_name} #{name} - Reminder"
  end


  # scopes
  def self.time_range(start_time, end_time)
    where('start_at >= ? AND start_at <= ?', Event.format_time(start_time), Event.format_time(end_time))
  end

  scope :by_start, -> { order('start_at ASC') }
  scope :from_today, -> { where('start_at >= ?', Time.zone.now.beginning_of_day) }


  # for calendar.js
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.name,
      :description => "",
      :start => self.start_at.rfc822,
      :end => self.end_at.rfc822,
      :allDay => false,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.event_path(id)
    }
  end

  def self.format_time(date_time)
    Time.zone.at(date_time.to_i).to_s(:db)
  end


  private
    def ensure_signup_token
      self.signup_token = valid_token
    end

    def valid_token
      loop do
        rand_token = generate_token
        break rand_token unless User.where(signup_token: rand_token).exists?
      end
    end

    def generate_token
      SecureRandom.urlsafe_base64(12)
    end
end
