class AddSettingsToUnit < ActiveRecord::Migration
  def change
    add_column :units, :address1, :string
    add_column :units, :address2, :string
    add_column :units, :zip_code, :string
    add_column :units, :consent_form_url, :string
    add_column :units, :attach_consent_form, :boolean, default: true
    add_column :units, :use_consent_form, :integer, default: 1
    add_column :units, :reply_to_default_user_id, :integer
  end
end
