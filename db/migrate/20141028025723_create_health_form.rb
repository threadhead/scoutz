class CreateHealthForm < ActiveRecord::Migration
  def change
    create_table :health_forms do |t|
      t.integer :unit_id
      t.integer :user_id

      t.date :part_a_date
      t.date :part_b_date
      t.date :part_c_date
      t.date :florida_sea_base_date
      t.date :philmont_date
      t.date :northern_tier_date
      t.date :summit_tier_date
    end
    add_index :health_forms, :unit_id
    add_index :health_forms, :user_id
  end
end
