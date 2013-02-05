class Event < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :users
  has_and_belongs_to_many :sub_units
  acts_as_gmappable

  attr_accessible :attire, :end_at, :kind, :location_address1, :location_address2, :location_city, :location_map_url, :location_name, :location_state, :location_zip_code, :name, :notifier_type, :organization_id, :send_reminders, :signup_deadline, :signup_required, :start_at, :user_id, :message, :sub_unit_ids

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

  before_save :sanitize_message
  def sanitize_message
    self.message = Sanitize.clean(message, Sanitize::Config::RELAXED)
  end

  def full_address
    "#{location_address1} #{}"
  end

  def self.time_range(start_time, end_time)
    where('start_at >= ? AND start_at <= ?', Event.format_time(start_time), Event.format_time(end_time))
  end

  def self.by_start
    order('start_at ASC')
  end

  def self.from_today
    where('start_at >= ?', Time.zone.now.beginning_of_day)
  end

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

end
