class AddKindIndexToEvent < ActiveRecord::Migration
  def change
    add_index :events, :kind
  end
end
