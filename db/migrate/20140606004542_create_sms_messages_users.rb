class CreateSmsMessagesUsers < ActiveRecord::Migration
  def change
    create_table :sms_messages_users, id: false do |t|
      t.references :sms_message
      t.references :user
    end
    add_index :sms_messages_users, [:sms_message_id, :user_id]
    add_index :sms_messages_users, [:user_id, :sms_message_id]
  end
end
