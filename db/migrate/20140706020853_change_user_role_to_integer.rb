class ChangeUserRoleToInteger < ActiveRecord::Migration
  # changed for compatibility for postgresql
  def up
    remove_index :users, :role
    remove_column :users, :role

    add_column :users, :role, :integer, default: 0
    add_index :users, :role
  end

  def down
    remove_index :users, :role
    remove_column :users, :role

    add_column :users, :role, :string
    add_index :users, :role
  end
end
