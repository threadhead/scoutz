class AddVerificationSentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_verification_sent_at, :datetime
  end
end
