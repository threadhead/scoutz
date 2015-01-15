class AddPermissionFormToEventSignup < ActiveRecord::Migration
  def change
    add_column :event_signups, :permission_at, :datetime
    add_column :event_signups, :permission_by, :integer
  end
end
