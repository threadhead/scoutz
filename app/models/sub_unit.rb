class SubUnit < ActiveRecord::Base
  attr_accessible :description, :name, :organization_id

  belongs_to :organization
  has_and_belongs_to_many :events
  # has_many :users
  has_many :scouts
  has_many :adults

  # validates :name,
  #           presence: true,
  #           uniqueness: { scope: :organization_id, case_sensitive: false }

  # validates_uniqueness_of :name

  def adults
    Adult.joins(scouts: :sub_unit).where(sub_units: {id: self.id} )
  end
end
