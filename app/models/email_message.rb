class EmailMessage < ActiveRecord::Base
  serialize :sub_unit_ids

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_many :email_attachments, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :email_attachments, allow_destroy: true

  attr_accessible :message, :subject, :user_id, :send_to_unit, :send_to_sub_units, :sub_unit_ids, :event_ids, :email_attachments_attributes, :user_ids, :send_to_option

  validates :message, presence: true
  validates :subject, presence: true

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


  def self.send_to_options(unit)
    [
      ["Everyone in #{unit.name}", '1'],
      ["Selected #{unit.sub_unit_name.pluralize}", '2'],
      ["Selected Adults/Scouts", '3']
    ]
  end


  #scopes
  def self.by_updated_at
    order('"email_messages"."updated_at" DESC')
  end
end
