class AddSendChoiceToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :send_to_option, :string
  end
end
