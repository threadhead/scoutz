class Phone < ActiveRecord::Base
  belongs_to :user
  # attr_accessible :kind, :number

  validates :kind, presence: true, uniqueness: { scope: :user_id }
  validates :number, presence: true, uniqueness: { scope: :user_id }
end
