class AddScoutlanderProfiles < ActiveRecord::Migration
  def change
    add_column :units, :sl_uid, :string
    add_column :events, :sl_profile, :string
    add_column :events, :sl_uid, :string
    add_column :users, :sl_profile, :string
    add_column :users, :sl_uid, :string
  end
end
