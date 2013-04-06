class AddScoutEventIndexToEventSignups < ActiveRecord::Migration
  def change
    add_index :event_signups, [:scout_id, :event_id]
  end
end
