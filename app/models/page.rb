class Page < ActiveRecord::Base
  include TrackableUpdates

  belongs_to :unit
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  acts_as_list scope: :unit

  validates :title, presence: true
  validates :body, presence: true

  before_save :sanitize_body
  def sanitize_body
    self.body = Sanitize.clean(body, whitelist)
  end


  private
    def whitelist
      whitelist = Sanitize::Config::RELAXED
      whitelist[:elements] << "span"
      whitelist[:attributes]["span"] = ["style"]
      whitelist
    end
end
