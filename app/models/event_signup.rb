class EventSignup < ActiveRecord::Base
  # include PublicActivity::Common

  belongs_to :event
  belongs_to :scout, class_name: "Scout", foreign_key: "scout_id"

  attr_accessible :adults_attending, :comment, :scouts_attending, :siblings_attending, :scout_id

  validates :adults_attending, numericality: { greater_than: -1 }
  validates :scouts_attending, numericality: { greater_than: -1 }
  validates :siblings_attending, numericality: { greater_than: -1 }
  validates :scout_id, uniqueness: {scope: :event_id}

  validate :at_least_one_attending
  def at_least_one_attending
    if adults_attending == 0 && scouts_attending == 0 && siblings_attending == 0
      errors.add(:base, "#{self.scout.try(:full_name)}: at least one person must attend.")
    end
  end

  after_save :update_event_attendee_count
  after_destroy :update_event_attendee_count
  def update_event_attendee_count
    self.event.update_attendee_count
  end

  def canceled?
    !canceled_at.nil?
  end

  def unit
    self.event.unit
  end

  ## scopes
  scope :for_event, -> event { where(event_id: event.id) }
  scope :by_scout_name_lf, -> { joins(:scout).order('"users"."last_name" ASC, "users"."first_name" ASC') }
end
