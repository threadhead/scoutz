class AddTimestampsToHealthForm < ActiveRecord::Migration
  def change
    add_column :health_forms, :created_at, :datetime
    add_column :health_forms, :updated_at, :datetime

    add_index :health_forms, :updated_at
  end
end
