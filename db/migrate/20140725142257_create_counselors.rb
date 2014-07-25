class CreateCounselors < ActiveRecord::Migration
  def change
    create_table :counselors do |t|
      t.references :merit_badge
      t.references :user
      t.references :unit

      t.timestamps
    end

    add_index :counselors, :merit_badge_id
    add_index :counselors, :user_id
    add_index :counselors, :unit_id
    add_index :counselors, [:merit_badge_id, :user_id, :unit_id], unique: true
  end
end
