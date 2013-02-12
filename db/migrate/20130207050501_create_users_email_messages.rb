class CreateUsersEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages_users, id: false do |t|
      t.references :email_message
      t.references :user
    end
    add_index :email_messages_users, [:email_message_id, :user_id]
    add_index :email_messages_users, [:user_id, :email_message_id]
  end
end
