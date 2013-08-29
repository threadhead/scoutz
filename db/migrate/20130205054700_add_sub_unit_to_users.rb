class AddSubUnitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sub_unit_id, :integer
    add_index :users, :sub_unit_id
  end
end
