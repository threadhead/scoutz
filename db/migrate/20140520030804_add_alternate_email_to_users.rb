class AddAlternateEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alternate_email, :string
  end
end
