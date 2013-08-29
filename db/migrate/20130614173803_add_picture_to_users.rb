class AddPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :picture, :string
    add_column :users, :picture_file_size, :integer
    add_column :users, :picture_content_type, :string
    add_column :users, :picture_original_file_name, :string
    add_column :users, :picture_updated_at, :datetime
  end
end
