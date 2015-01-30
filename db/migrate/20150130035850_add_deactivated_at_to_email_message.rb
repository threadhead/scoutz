class AddDeactivatedAtToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :deactivated_at, :datetime
  end
end
