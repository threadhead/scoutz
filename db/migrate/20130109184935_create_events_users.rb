class CreateEventsUsers < ActiveRecord::Migration
  def change
    create_table :events_users, id: false do |t|
      t.integer :event_id
      t.integer :user_id
    end
    add_index :events_users, [:event_id, :user_id]
    add_index :events_users, [:user_id, :event_id]
  end
end
