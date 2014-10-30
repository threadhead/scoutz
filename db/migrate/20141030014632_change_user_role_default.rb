class ChangeUserRoleDefault < ActiveRecord::Migration
  def up
    change_column_default(:users, :role, 10)  #basic
  end

  def down
    change_column_default(:users, :role, 0)  # the original, though not necessary
  end
end
