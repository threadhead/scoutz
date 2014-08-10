class UnitPosition < ActiveRecord::Base
  belongs_to :user

  validates :unit_id, presence: true
end
