class CreateMeritBadgesUsers < ActiveRecord::Migration
  def change
    create_table :merit_badges_users, id: false do |t|
      t.references :merit_badge
      t.references :user
    end
    add_index :merit_badges_users, [:merit_badge_id, :user_id]
    add_index :merit_badges_users, [:user_id, :merit_badge_id]
  end

end
