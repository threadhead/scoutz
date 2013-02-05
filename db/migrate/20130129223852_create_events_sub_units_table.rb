class CreateEventsSubUnitsTable < ActiveRecord::Migration
  def change
    create_table :events_sub_units, :id => false do |t|
      t.references :event
      t.references :sub_unit
    end
    add_index :events_sub_units, [:event_id, :sub_unit_id]
    add_index :events_sub_units, [:sub_unit_id, :event_id]
  end

end
