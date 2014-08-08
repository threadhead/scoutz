class Page < ActiveRecord::Base
  include TrackableUpdates
  include AttributeSanitizer

  belongs_to :unit
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  acts_as_list scope: :unit

  validates :title, presence: true, length: {in: 1..48}
  validates :body, presence: true

  sanitize_attributes(:body)
  scope :front_pages, -> { where(front_page: true) }
end
