class AddCarpoolToEventSignups < ActiveRecord::Migration
  def change
    add_column :event_signups, :need_carpool_seats, :integer, default: 0
    add_column :event_signups, :has_carpool_seats, :integer, default: 0
  end
end
