class AddUuidSeqIcalToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ical_sequence, :integer, default: 0
    add_column :events, :ical_uuid, :string
  end
end
