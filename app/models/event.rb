class Event < ActiveRecord::Base
  include EventCalendar
  include EventReminders
  include AttributeSanitizer
  include PgSearch
  include DateTimeAttributes

  serialize :form_coordinator_ids, Array

  belongs_to :unit
  has_many :event_signups, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :sub_units
  has_and_belongs_to_many :email_messages
  # acts_as_gmappable process_geocoding: false, validation: false

  date_time_attribute :start_at, :end_at, :signup_deadline

  enum type_of_health_forms: {
    not_required:       0,
    parts_ab:           10,
    parts_abc:          20,
    northern_tier:      30,
    florida_sea_base:   40,
    philmont:           50,
    summit:             60
  }


  validates :name, :start_at, :end_at, :message, :kind,
            presence: true

  validates :sl_profile, uniqueness: { allow_nil: true }
  validates :signup_deadline, presence: true, if: :signup_required?

  validate :signup_deadline_before_start
  def signup_deadline_before_start
    return unless signup_required? && start_at && signup_deadline
    errors.add(:signup_deadline, 'must be before the start time') if signup_deadline >= start_at
  end

  validate :validate_start_at_before_end_at
  def validate_start_at_before_end_at
    return unless end_at && start_at
    errors.add(:end_at, 'must be after the start time') if end_at <= start_at
  end

  sanitize_attributes :message



  def meta_search_json(unit_scope:)
    { resource: 'event',
      initials: 'E',
      id: id,
      name: name,
      desc: "#{start_at.to_s(:short_ampm)}",
      url: Rails.application.routes.url_helpers.unit_event_path(unit_scope, id)
    }
  end

  def self.meta_search_json(events)
    events.map(&:meta_search_json).to_json
  end



  def gmaps4rails_address
    # describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    # "#{self.location_address1}, #{self.location_city}, #{self.location_state}"
    [location_address1, location_city, location_state].reject(&:blank?).join(', ')
  end


  def unit_meeting_kind?
    return false if kind.blank?
    !!(kind =~ /troop meeting|pack meeting|crew meeting|lodge meeting/i)
  end

  def camping_outing_kind?
    return false if kind.blank?
    !!(kind =~ /camping/i)
  end

  def unit_event_kind?
    return false if kind.blank?
    !!(kind =~ /troop event|pack event|crew event|lodge event/i)
  end

  def plc_kind?
    return false if kind.blank?
    !!(kind =~ /plc/i)
  end

  def unit_meeting_event_camping_plc_kind?
    unit_meeting_kind? || plc_kind? || unit_event_kind? || camping_outing_kind?
  end




  def adult_leader_kind?
    return false if kind.blank?
    !!(kind =~ /adult leader event/i)
  end

  def sub_unit_kind?
    return false if kind.blank?
    !!(kind =~ /patrol event|den event/i)
  end




  before_create :ensure_signup_token


  # DO NOT RE-ENABLE!
  # now handled in after_save, after_destroy callback in EventSignup
  # after_save :update_attendee_count

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



  def full_location
    @full_location ||= [location_name, location_address1, location_address2, location_city, "#{location_state} #{location_zip_code}".strip].reject(&:blank?).join(', ')
  end


  def list_name
    "#{Google::TimeDisplay.new(start_at)} • #{name} (#{event_kind_details})"
    # "#{start_at.to_s(:short_ampm)} - #{name} (#{event_kind_details})"
  end

  def event_kind_details
    if sub_unit_kind?
      event_kind_sub_units
    else
      kind
    end
  end

  def event_kind_sub_units
    self.sub_units.map(&:name).join(', ')
  end




  def after_signup_deadline?
    signup_deadline <= Time.zone.now
  end

  def user_signups(event_user)
    event_user.unit_family(self.unit).order(type: :desc).map do |user|
      self.event_signups.where(user_id: user.id).first || EventSignup.new(user_id: user.id, event_id: self.id)
    end
  end

  def users_without_signup
    all_ids = unit.users.pluck(:id)
    signed_up_ids = event_signups.pluck(:user_id)
    User.where(id: all_ids - signed_up_ids).by_name_lf
    # unit.scouts.by_name_lf - Scout.where(id: event_signups.pluck(:scout_id))
  end

  def event_signup_users
    user_ids = self.event_signups.pluck(:user_id)
    users_with_email = User.where(id: user_ids).with_email
    adults_with_email = Adult.uniq.with_email.joins(:scouts).where(user_relationships: { scout_id: user_ids })
    (users_with_email + adults_with_email).uniq
  end

  def event_signup_user_ids
    event_signup_users.map(&:id)
  end

  def user_has_signup?(user)
    user_signups(user).any?(&:persisted?)
  end

  def email_messages_for_display(ignore_email_message: nil)
    # no need to display emails messages that have no message content
    em = email_messages.where.not(email_messages: { message: '' })

    # if an email_message is passed, we want to ignore it as it is the containing message
    em = em.where.not(email_messages: { id: ignore_email_message.id }) unless ignore_email_message.nil?

    em.order(:sent_at)
  end



  def form_coordinators
    if has_form_coordinators
      # adults in the form_coordinators_ids list, or an admin
      # t = User.arel_table
      # unit.adults.where(t[:id].in(form_coordinator_ids.reject(&:empty?)).or(t[:role].gteq(User.roles[:admin])))
      unit.adults.where(id: form_coordinator_ids.reject(&:empty?))
    else
      unit.adults.role_is_leader_or_above
    end
  end

  def form_coordinator?(user)
    return false unless user.adult?
    return true if user.role_at_least(:admin)

    if has_form_coordinators
      form_coordinator_ids.include? user.id.to_s
    else
      unit.adults.role_is_leader_or_above.exists?(id: user.id)
    end
  end

  def has_form_coordinators
    !form_coordinator_ids.reject(&:empty?).empty?
  end


  # the types of health forms required based on the event's type_of_health_forms selection
  def health_forms_required
    case type_of_health_forms
    when 'not_required'
      []
    when 'parts_ab'
      [:part_a_expires, :part_b_expires]
    when 'parts_abc'
      [:part_a_expires, :part_b_expires, :part_c_expires]
    when 'northern_tier'
      [:part_a_expires, :part_b_expires, :part_c_expires, :northern_tier_expires]
    when 'florida_sea_base'
      [:part_a_expires, :part_b_expires, :part_c_expires, :florida_sea_base_expires]
    when 'summit'
      [:part_a_expires, :part_b_expires, :part_c_expires, :summit_tier_expires]
    when 'philmont'
      [:part_a_expires, :part_b_expires, :part_c_expires, :philmont_expires]
    else
      []
    end
  end

  def health_forms_required?
    type_of_health_forms != 'not_required'
  end

  def self.type_of_health_forms_for_select
    {
      'Not required'                                  => 'not_required',
      'All activities (Parts A/B)'                    => 'parts_ab',
      'Camps & activities > 72 hours (Parts A/B/C)'   => 'parts_abc',
      'Norther Tier (Parts A/B/C + NT)'               => 'northern_tier',
      'Florida Sea Base (Parts A/B/C + FSB)'          => 'florida_sea_base',
      'Philmont (Parts A/B/C + P)'                    => 'philmont',
      'Summit (Parts A/B/C + S)'                      => 'summit'
    }
  end




  # scopes
  def self.time_range(start_date, end_date)
    st = DateTime.parse(start_date)
    ed = DateTime.parse(end_date)
    where('("events"."start_at" BETWEEN ? AND ?) OR ("events"."end_at" BETWEEN ? AND ?)', st, ed, st, ed)
    # where('start_at >= ? AND start_at <= ?', Event.format_time(start_date), Event.format_time(end_date))
    # where(start_at: DateTime.parse(start_date)..DateTime.parse(end_date))
  end

  def self.now_plus_months(months)
    st = Time.zone.now.beginning_of_day
    ed = (Time.zone.now + months.to_i.months).end_of_month
    where('("events"."start_at" BETWEEN ? AND ?) OR ("events"."end_at" BETWEEN ? AND ?)', st, ed, st, ed)
  end


  scope :by_start, -> { order('start_at ASC') }
  # scope :from_today, -> { where('start_at >= ?', Time.zone.now.beginning_of_day) }
  scope :from_today, -> { where('start_at >= ? OR end_at >= ?', Time.zone.now.beginning_of_day, Time.zone.now.beginning_of_day) }
  scope :newsletter_next_week, -> { where(start_at: Time.zone.now.beginning_of_day..Time.zone.now.next_week.end_of_week) }
  scope :newsletter_next_month, -> { where(start_at: Time.zone.now.next_month.beginning_of_month..Time.zone.now.next_month.end_of_month) }
  # scope :contains_search, ->(n) { where("events.name ILIKE ? OR events.location_name ILIKE ? OR events.message ILIKE ?", "%#{n}%", "%#{n}%", "%#{n}%") }
  # scope :contains_search, ->(n) { where("to_tsvector('english', name) @@ to_tsquery('english', ?)", n) }

  pg_search_scope :pg_meta_search,
                  against: { name: 'A', location_name: 'B', message: 'C' },
                  using: {
                    tsearch: { dictionary: 'english', any_word: true, prefix: true },
                    trigram: { threshold: 0.5 }
                  }

  def self.meta_search(unit_scope: nil, keywords:)
    meta_events = unit_scope.nil? ? Event.all : unit_scope.events
    # meta_events.from_today.contains_search(keywords).by_start
    meta_events.from_today.pg_meta_search(keywords)
  end


  def self.last_unit_meeting(unit)
    where(unit: unit, kind: "#{unit.unit_type_title} Meeting").order(start_at: :desc).first
  end


  def disable_reminder_if_old
    return unless start_at <= 2.days.ago
    self.reminder_sent_at = Time.at(0).to_datetime
  end


  # for calendar.js
  def as_json(_options={})
    {
      id:             self.id,
      title:          self.name,
      description:    '',
      start:          self.start_at.iso8601,
      end:            self.end_at.iso8601,
      allDay:         false,
      recurring:      false,
      url:            Rails.application.routes.url_helpers.unit_event_path(unit, id),
      color:          unit.unit_type == 'Boy Scouts' ? 'darkkhaki' : 'midnightblue'
    }
  end

  def to_copy_meeting_json
    {
      id:           id,
      name:         name,
      start_at:     start_at.try(:iso8601),
      end_at:       end_at.try(:iso8601),
      send_reminders: send_reminders,
      signup_required: signup_required,
      signup_deadline: signup_deadline.try(:iso8601),
      location_name: location_name,
      location_address1: location_address1,
      location_address2: location_address2,
      location_city: location_city,
      location_state: location_state,
      location_zip_code: location_zip_code,
      location_map_url: location_map_url,
      attire: attire,
      message: message,
      type_of_health_forms: type_of_health_forms,
      consent_required: consent_required,
      form_coordinator_ids: form_coordinator_ids
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
