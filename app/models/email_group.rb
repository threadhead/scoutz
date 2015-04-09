class EmailGroup < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user

  serialize :users_ids, Array

  validates :unit, :user, :name, presence: true

  validate :users_ids_not_empty
  def users_ids_not_empty
    errors.add(:base, "You must select at least one user") if users_ids.empty?
  end


  def users
    unit.users.where(id: users_ids).by_name_lf
  end
end
