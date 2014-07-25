class Counselor < ActiveRecord::Base
  belongs_to :merit_badge
  belongs_to :user, inverse_of: :counselors
  belongs_to :unit
end
