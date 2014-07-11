class ChangeUserRoleToInteger < ActiveRecord::Migration
  def up
    remove_index :users, :role
    change_column :users, :role, :integer, default: 0
    add_index :users, :role
  end

  def down
    remove_index :users, :role
    change_column :users, :role, :string
    add_index :users, :role
  end
end
