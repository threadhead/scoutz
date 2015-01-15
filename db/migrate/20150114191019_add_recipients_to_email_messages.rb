class AddRecipientsToEmailMessages < ActiveRecord::Migration
  def change
    add_column :email_messages, :sent_to_hash, :text, default: Hash.new
  end
end
