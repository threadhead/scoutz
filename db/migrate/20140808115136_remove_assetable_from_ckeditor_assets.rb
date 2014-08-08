class RemoveAssetableFromCkeditorAssets < ActiveRecord::Migration
  def change
    remove_column :ckeditor_assets, :assetable_id
    remove_column :ckeditor_assets, :assetable_type
  end
end
