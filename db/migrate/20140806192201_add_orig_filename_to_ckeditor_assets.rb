class AddOrigFilenameToCkeditorAssets < ActiveRecord::Migration
  def change
    add_column :ckeditor_assets, :data_original_file_name, :string
  end
end
