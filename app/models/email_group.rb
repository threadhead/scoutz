class EmailGroup < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user

  serialize :users_ids, Array

  validates :unit, :user, :name, presence: true

  validate :users_ids_not_empty
  def users_ids_not_empty
    errors.add(:base, "You must select at least one user") if users_ids.empty?
  end


  default_scope { order(:name) }

  def users
    unit.users.where(id: users_ids).by_name_lf
  end

  def users_with_adults
    User.unit_users_with_adults(unit: unit, users_ids: users_ids).by_name_lf
  end
end
