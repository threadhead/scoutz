class AddRequireConsentToEvent < ActiveRecord::Migration
  def change
    add_column :events, :consent_required, :boolean
    add_column :events, :form_coordinator_ids, :string, default: []
  end
end
