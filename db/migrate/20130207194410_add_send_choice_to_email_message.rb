class AddSendChoiceToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :send_to_option, :integer, default: 1
  end
end
