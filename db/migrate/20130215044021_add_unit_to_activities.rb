class AddUnitToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :unit_id, :integer
    add_index :activities, :unit_id
  end
end
