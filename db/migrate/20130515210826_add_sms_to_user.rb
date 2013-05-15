class AddSmsToUser < ActiveRecord::Migration
  def change
    add_column :users, :sms_number, :string
    add_column :users, :sms_number_verified_at, :datetime
  end
end
