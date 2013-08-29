class AddIndexesLeadershipToUser < ActiveRecord::Migration
  def change
    add_index :users, :leadership_position
    add_index :users, :additional_leadership_positions
  end
end
