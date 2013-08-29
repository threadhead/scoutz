class AddIndexUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_index :users, :updated_at
    add_index :events, :updated_at
    add_index :email_messages, :updated_at
  end
end
