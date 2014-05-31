class AddSmsMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_message, :boolean, default: true
  end
end
