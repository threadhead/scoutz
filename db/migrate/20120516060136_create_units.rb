class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :unit_type
      t.string :unit_number
      t.string :city
      t.string :state
      t.string :time_zone

      t.timestamps
    end
  end
end
