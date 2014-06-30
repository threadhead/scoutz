module EventCalendar
  require 'tempfile'
  extend ActiveSupport::Concern

  included do
    mount_uploader :ical, IcalUploader
    before_create :ensure_ical_uuid
    before_save :update_ical_attributes
    after_save :update_ical_background, if: :ical_valid?
  end

  module ClassMethods
    def update_ical(event_id)
      event = Event.find(event_id)
      event.update_ical if event
    end

    def update_all_ical
      Event.pluck(:id).each{ |event_id| Event.delay(priority: -5).update_ical(event_id) }
    end
  end

  def ical_valid?
    !(self.start_at.blank? || self.end_at.blank? || self.name.blank?)
  end

  def update_ical_background
    Event.delay(priority: -5).update_ical(self.id)
  end

  def update_ical
    return unless ical_valid?
    # puts "REALLY UPDATE_ICAL"
    self.increment(:ical_sequence) if ical.present?

    skip_update_ical_background_callbacks do
      in_temp_file do |temp_file|
        file = File.open(temp_file, 'w')
        file.write ical_string
        self.ical = file
        update_ical_attributes
        self.class.record_timestamps = false
        self.save!
        self.class.record_timestamps = true
        file.close
      end
    end
  end

  def in_temp_file
    temp_file = Tempfile.new([self.ical_uuid, '.ics'])

    yield temp_file

    temp_file.close
    temp_file.unlink #delete the temp file
  end

  def skip_update_ical_background_callbacks
    Event.skip_callback(:save, :after, :update_ical_background)
    yield
    Event.set_callback(:save, :after, :update_ical_background)
  end

  def ical_string
    # return unless ical_valid?
    cal = Icalendar::Calendar.new
    e = self
    cal.event do |e|
      e.ip_class      = "PRIVATE"
      e.dtstart       = self.start_at.utc.to_s(:ical)
      e.dtend         = self.end_at.utc.to_s(:ical)
      e.summary       = self.name
      e.description   = Sanitize.clean(self.message, whitespace_elements: [])
      # e.location    =   self.full_location, {"ALTREP" => ["\"#{self.location_map_url}\""]}
      e.location      = self.full_location
      e.uid           = self.ical_uuid
      e.sequence      = self.ical_sequence
      e.url           = Rails.application.routes.url_helpers.event_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
    end
    cal.to_ical
  end

  private
    def ensure_ical_uuid
      self.ical_uuid = SecureRandom.uuid
    end

    def update_ical_attributes
      if ical.present? && ical_changed?
        self.ical_content_type = 'text/calendar'
        self.ical_file_size = ical.file.size
        self.ical_updated_at = Time.zone.now
      end
    end

end
