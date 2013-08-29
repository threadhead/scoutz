class CreateSubUnits < ActiveRecord::Migration
  def change
    create_table :sub_units do |t|
      t.integer :unit_id
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :sub_units, :unit_id
  end
end
