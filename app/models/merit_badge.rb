class MeritBadge < ActiveRecord::Base
  include PgSearch

  has_many :counselors, inverse_of: :merit_badge, dependent: :destroy, autosave: true do
    def unit(unit_id)
      where(counselors: { unit_id: unit_id })
    end
  end
  accepts_nested_attributes_for :counselors,
        reject_if: proc { |att| att['user_id'].blank? || att['user_id'] == '0' },
        allow_destroy: true

  has_many :users, through: :counselors

  validates :name, uniqueness: true, presence: true


  def unit_counselors(unit_id)
    self.users.where(counselors: { unit_id: unit_id })
  end

  def create_unit_counselor(options={})
    Counselor.create({ merit_badge_id: self.id }.merge(options))
  end

  def build_unit_counselor(options={})
    Counselor.new({ merit_badge_id: self.id }.merge(options))
  end

  def initials
    name[0]
  end


  # Scopes
  scope :by_name, -> { order(name: :asc) }
  scope :name_contains, ->(n) { where('merit_badges.name ILIKE ?', "%#{n}%") }
  pg_search_scope :pg_meta_search,
    against: [:name],
    using: {
             tsearch: { dictionary: 'english', any_word: true, prefix: true },
             trigram: { threshold: 0.5 }
           }


  def self.meta_search(unit_scope: nil, keywords:)
    meta_merit_badges = unit_scope.nil? ? MeritBadge.all : MeritBadge.where(unit_id: unit_scope.id)
    meta_merit_badges.pg_meta_search(keywords)
  end

  def self.meta_search_counselors(unit_scope: nil, keywords:)
    MeritBadge.joins(:counselors).where(counselors: { unit_id: unit_scope.id, user_id: User.pg_meta_search(keywords).map(&:id) })
  end


  def meta_search_json(unit_scope:)
    { resource: 'merit badge',
      initials: initials,
      id: id,
      name: name,
      desc: '&nbsp;',
      url: Rails.application.routes.url_helpers.unit_merit_badge_path(unit_scope, id)
    }
  end




  # use by UsersController to create the counselors_attributes hash
  def self.create_counselors_attributes(users_ids: user_ids, unit:, merit_badge: nil)
    # {"0"=>{"unit_id"=>"15", "user_id"=>"22"}, "1"=>{"unit_id"=>"15", "user_id"=>"22"}}}

    # use only unique, non-empty values (helps with validation)
    user_ids_uniq = users_ids.reject(&:empty?).uniq
    idx = 0
    h = Hash.new

    if merit_badge
      merit_badge.counselors.unit(unit.id).each do |c|
        # if the existing counselor's meritbadge exists in the array of mb_ids_uniq, set _destroy -> '0'
        # if the existing counselor's meritbadge does not exist in the array of mb_ids_uniq, then mark it for deletion, _destroy -> '1'
        dest = user_ids_uniq.include?(c.user_id.to_s) ? '0' : '1'

        h["#{idx}"] = {
                        'id' => "#{c.id}",
                        'unit_id' => "#{c.unit_id}",
                        'user_id' => "#{c.user_id}",
                        '_destroy' => dest
                      }
        idx += 1
      end
    end

    # get the difference in user ids from what currently exists. the diff will be NEW records to create
    user_diff = merit_badge.nil? ? user_ids_uniq : (user_ids_uniq - merit_badge.counselors.unit(unit.id).map { |c| c.user_id.to_s })
    user_diff.each do |uid|
      h["#{idx}"] = {
                      'unit_id' => "#{unit.id}",
                      'user_id' => uid,
                      '_destroy' => '0'
                    }
      idx += 1
    end

    h
  end

end
