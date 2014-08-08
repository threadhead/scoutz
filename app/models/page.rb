class Page < ActiveRecord::Base
  include TrackableUpdates

  belongs_to :unit
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  acts_as_list scope: :unit

  validates :title, presence: true, length: {in: 1..48}
  validates :body, presence: true

  before_save :sanitize_body
  def sanitize_body
    self.body = Sanitize.clean(body, whitelist)
  end


  scope :front_pages, -> { where(front_page: true) }

  private
    def whitelist
      whitelist = Sanitize::Config::RELAXED
      whitelist[:elements] << "span"
      whitelist[:attributes][:all] << "style"
      whitelist
    end
end
