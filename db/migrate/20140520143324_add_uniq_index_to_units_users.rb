class AddUniqIndexToUnitsUsers < ActiveRecord::Migration
  def change
    remove_index :units_users, [:unit_id, :user_id]
    remove_index :units_users, [:user_id, :unit_id]

    add_index :units_users, [:unit_id, :user_id], unique: true
    add_index :units_users, [:user_id, :unit_id], unique: true
  end
end
