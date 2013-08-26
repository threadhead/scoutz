class AddIcalToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ical, :string
    add_column :events, :ical_file_size, :integer
    add_column :events, :ical_content_type, :string
    add_column :events, :ical_updated_at, :datetime
  end
end
