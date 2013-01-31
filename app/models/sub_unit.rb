class SubUnit < ActiveRecord::Base
  attr_accessible :description, :name, :organization_id

  belongs_to :organization
  has_and_belongs_to_many :events

  # validates :name,
  #           presence: true,
  #           uniqueness: { scope: :organization_id, case_sensitive: false }

  # validates_uniqueness_of :name
end
