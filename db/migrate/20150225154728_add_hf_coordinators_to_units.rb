class AddHfCoordinatorsToUnits < ActiveRecord::Migration
  def change
    add_column :units, :health_form_coordinator_ids, :string, default: []
  end
end
