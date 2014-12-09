class AddUpdateAtIndexToMeritBadge < ActiveRecord::Migration
  def change
    add_index :merit_badges, :updated_at
  end
end
