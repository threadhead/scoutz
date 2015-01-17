class AddConsentFormAttachmentToUnit < ActiveRecord::Migration
  def change
    add_column :units, :consent_form, :string
    add_column :units, :consent_form_updated_at, :datetime
    add_column :units, :consent_form_file_size, :integer
    add_column :units, :consent_form_content_type, :string
    add_column :units, :consent_form_original_file_name, :string
  end
end
