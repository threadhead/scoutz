class AddNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :blast_email, :boolean, default: true
    add_column :users, :blast_sms, :boolean
    add_column :users, :event_reminder_email, :boolean, default: true
    add_column :users, :event_reminder_sms, :boolean
    add_column :users, :signup_deadline_email, :boolean, default: true
    add_column :users, :signup_deadline_sms, :boolean
  end
end
