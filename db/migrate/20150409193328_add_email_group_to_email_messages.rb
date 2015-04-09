class AddEmailGroupToEmailMessages < ActiveRecord::Migration
  def change
    add_column :email_messages, :email_group_id, :integer
  end
end
