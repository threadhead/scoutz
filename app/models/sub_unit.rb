class SubUnit < ActiveRecord::Base
  # attr_accessible :description, :name, :unit_id

  belongs_to :unit
  has_and_belongs_to_many :events
  # has_many :users
  has_many :scouts
  has_many :adults

  # validates :name,
  #           presence: true,
  #           uniqueness: { scope: :unit_id, case_sensitive: false }

  # validates_uniqueness_of :name

  def adults
    Adult.joins(scouts: :sub_unit).where(sub_units: {id: self.id} )
  end

  def users_with_emails
    adults.with_email + self.scouts.with_email
  end

  # scopes
  scope :by_name, -> { order('"sub_units"."name" ASC') }

end
