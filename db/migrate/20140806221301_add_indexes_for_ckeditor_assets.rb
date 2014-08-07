class AddIndexesForCkeditorAssets < ActiveRecord::Migration
  def change
    add_index :ckeditor_assets, :type
    add_index :ckeditor_assets, :updated_at

    remove_index :ckeditor_assets, name: :idx_ckeditor_assetable
    remove_index :ckeditor_assets, name: :idx_ckeditor_assetable_type
  end
end
