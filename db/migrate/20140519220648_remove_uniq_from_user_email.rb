class RemoveUniqFromUserEmail < ActiveRecord::Migration
  # can not have a unique index for the email column, causes problems with validations
  def change
    remove_index :users, :email
    add_index :users, :email
  end
end
