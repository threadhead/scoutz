class Counselor < ActiveRecord::Base
  belongs_to :merit_badge, touch: true
  belongs_to :user, inverse_of: :counselors, touch: true
  belongs_to :unit
end
