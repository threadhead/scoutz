class AddHomeLocationToUnit < ActiveRecord::Migration
  def change
    add_column :units, :home_name, :string
    add_column :units, :home_address1, :string
    add_column :units, :home_address2, :string
    add_column :units, :home_city, :string
    add_column :units, :home_state, :string
    add_column :units, :home_zip_code, :string
    add_column :units, :home_map_url, :string
  end
end
