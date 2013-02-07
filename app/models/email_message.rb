class EmailMessage < ActiveRecord::Base
  serialize :sub_unit_ids

  belongs_to :sender, class_name: "User", foreign_key: "user_id"
  belongs_to :unit
  has_many :email_attachments, dependent: :destory
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users

  attr_accessible :message, :subject, :user_id, :send_to_unit, :send_to_sub_units, :sub_unit_ids, :event_ids

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


  #scopes
  def self.by_updated_at
    order('"email_messages"."updated_at" DESC')
  end
end
