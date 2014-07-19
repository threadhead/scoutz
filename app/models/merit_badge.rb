class MeritBadge < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, uniqueness: true, presence: true

  # Scopes
  def counselors(unit)
    self.users.by_name_lf.joins(:units).where(units:{id: unit.id})
  end

  scope :by_name, -> { order(name: :asc) }
  scope :name_contains, ->(n) { where("merit_badges.name ILIKE ?", "%#{n}%") }

end
