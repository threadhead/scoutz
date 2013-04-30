class AddSignupTokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :signup_token, :string
    add_index :events, :signup_token
  end
end
