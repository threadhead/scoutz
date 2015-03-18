class AddUserToEventSignup < ActiveRecord::Migration
  def change
    add_column :event_signups, :user_id, :integer
    add_index :event_signups, :user_id
  end
end
