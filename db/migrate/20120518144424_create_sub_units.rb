class CreateSubUnits < ActiveRecord::Migration
  def change
    create_table :sub_units do |t|
      t.integer :organization_id
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :sub_units, :organization_id
  end
end
