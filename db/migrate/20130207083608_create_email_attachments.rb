class CreateEmailAttachments < ActiveRecord::Migration
  def change
    create_table :email_attachments do |t|
      t.integer :email_message_id
      t.string :attachment
      t.integer :file_size
      t.string :content_type
      t.string :original_file_name

      t.timestamps
    end

    add_index :email_attachments, :email_message_id
  end
end
