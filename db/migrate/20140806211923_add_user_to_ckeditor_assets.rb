class AddUserToCkeditorAssets < ActiveRecord::Migration
  def change
    add_column :ckeditor_assets, :user_id, :integer

    add_index :ckeditor_assets, :user_id
    add_index :ckeditor_assets, :unit_id
  end
end
