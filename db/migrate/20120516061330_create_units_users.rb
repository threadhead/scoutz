class CreateUnitsUsers < ActiveRecord::Migration
  def change
    create_table :units_users do |t|
      t.references :unit
      t.references :user
    end
    add_index :units_users, [:unit_id, :user_id]
    add_index :units_users, [:user_id, :unit_id]
  end
end
