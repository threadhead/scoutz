class CreateUnitPositions < ActiveRecord::Migration
  def change
    create_table :unit_positions do |t|
      t.references :user
      t.references :unit
      t.string :leadership
      t.string :additional
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :unit_positions, [:user_id, :unit_id]
  end
end
