class AddMiscToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rank, :string
    add_column :users, :send_reminders, :boolean
    add_column :users, :deactivated_at, :datetime
    add_column :users, :leadership_position, :string
    add_column :users, :additional_leadership_positions, :string

    add_index :users, :send_reminders
    add_index :users, :deactivated_at
  end
end
