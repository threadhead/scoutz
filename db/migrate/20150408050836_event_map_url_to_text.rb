class EventMapUrlToText < ActiveRecord::Migration
  def change
    change_column :events, :location_map_url, :text
  end
end
