class HealthForm < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit

  validates :user_id, presence: true
  validates :unit_id, presence: true
end
