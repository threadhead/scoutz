class AddReminderSentAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reminder_sent_at, :datetime
    add_index :events, :reminder_sent_at
    add_index :events, :send_reminders
  end
end
