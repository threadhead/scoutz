class AddIdTokenToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :id_token, :string
    add_index :email_messages, :id_token
  end
end
