class RemoveUserIdFromEvents < ActiveRecord::Migration
  def up
    remove_index :events, :user_id
    remove_column :events, :user_id
  end

  def down
    add_column :events, :user_id
    add_index :events, :user_id
  end
end
