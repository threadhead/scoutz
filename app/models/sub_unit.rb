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


  # find adults in sub_unit through their associated scouts
  def adults
    Adult.joins(scouts: :sub_unit).where(sub_units: {id: self.id} )
  end

  def users_with_emails
    adults.with_email + scouts.with_email
  end

  def users_receiving_email_blast
    adults.with_email.gets_email_blast + scouts.with_email.gets_email_blast
  end

  def users_receiving_sms_blast
    adults.with_sms.gets_sms_blast + scouts.with_sms.gets_sms_blast
  end

  # scopes
  scope :by_name, -> { order('"sub_units"."name" ASC') }

end
