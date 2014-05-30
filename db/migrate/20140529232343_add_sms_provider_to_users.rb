class AddSmsProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_provider, :string
  end
end
