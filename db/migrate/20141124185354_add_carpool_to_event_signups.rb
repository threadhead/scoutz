class AddCarpoolToEventSignups < ActiveRecord::Migration
  def change
    add_column :event_signups, :need_carpool_seats, :integer, default: nil
    add_column :event_signups, :has_carpool_seats, :integer, default: nil
  end
end
