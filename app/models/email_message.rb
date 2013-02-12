class EmailMessage < ActiveRecord::Base
  serialize :sub_unit_ids

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_many :email_attachments, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :email_attachments, allow_destroy: true

  attr_accessible :message, :subject, :user_id, :sub_unit_ids, :event_ids, :email_attachments_attributes, :user_ids, :send_to_option

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
      "Selected #{to_unit.sub_unit_name.pluralize}"
    when 3
      "Selected Adults/Scouts"
    end
  end

  def has_attachments?
    self.email_attachments.count > 0
  end


  def send_to_count
    recipients.count
  end

  def recipients
    case send_to_option
    when 1
      self.unit.users.with_email
    when 2
      su_users = []
      sub_units.each { |su| su_users << su.users_with_emails }
      su_users.flatten
      # Scout.with_email.joins(:sub_unit).where(sub_units: {id: sub_unit_ids}) +
      # Adult.with_email.joins(:sub_unit).where(sub_units: {id: sub_unit_ids})
    when 3
      self.users.with_email
    end
  end

  def sub_units
    SubUnit.where(id: sub_unit_ids)
  end

  def send_to_sub_units?
    send_to_option == 2
  end

  def send_to_unit?
    send_to_option == 1
  end

  def send_to_users?
    send_to_option == 3
  end


  def self.send_to_options(unit)
    [
      ["Everyone in #{unit.name}", 1],
      ["Selected #{unit.sub_unit_name.pluralize}", 2],
      ["Selected Adults/Scouts", 3]
    ]
  end

  before_save :sanitize_message
  def sanitize_message
    self.message = Sanitize.clean(message, Sanitize::Config::RELAXED)
  end


  #scopes
  def self.by_updated_at
    order('"email_messages"."updated_at" DESC')
  end
end
