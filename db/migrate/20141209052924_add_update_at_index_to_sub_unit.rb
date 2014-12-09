class AddUpdateAtIndexToSubUnit < ActiveRecord::Migration
  def change
    add_index :sub_units, :updated_at
  end
end
