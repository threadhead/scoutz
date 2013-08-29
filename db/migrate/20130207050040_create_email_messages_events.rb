class CreateEmailMessagesEvents < ActiveRecord::Migration
  def change
    create_table :email_messages_events, id: false do |t|
      t.references :email_message
      t.references :event
    end
    add_index :email_messages_events, [:email_message_id, :event_id]
    add_index :email_messages_events, [:event_id, :email_message_id]
  end
end
