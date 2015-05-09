class SubUnit < ActiveRecord::Base
  # attr_accessible :description, :name, :unit_id

  belongs_to :unit
  has_and_belongs_to_many :events
  # has_many :users
  has_many :scouts
  has_many :adults

  validates :name,
            presence: true,
            uniqueness: { scope: :unit_id, case_sensitive: false }


  def type
    self.unit.sub_unit_name
  end

  default_scope { order(:name) }

  # find adults in sub_unit through their associated scouts
  def adults
    Adult.joins(scouts: :sub_unit).where(sub_units: { id: self.id })
  end

  def users_with_emails
    adults.with_email + scouts.with_email
  end

  def users_with_sms
    adults.gets_sms_message + scouts.gets_sms_message
  end

  def users_receiving_email_blast
    adults.gets_email_blast + scouts.gets_email_blast
  end

  def users_receiving_sms_blast
    adults.gets_sms_blast + scouts.gets_sms_blast
  end

  def users_receiving_email_reminder
    adults.gets_email_reminder + scouts.gets_email_reminder
  end

  def users_receiving_sms_reminder
    adults.gets_sms_reminder + scouts.gets_sms_reminder
  end

  def users_receiving_sms_message
    adults.gets_sms_message + scouts.gets_sms_message
  end

  # scopes
  scope :by_name, -> { order(name: :asc) }

end
