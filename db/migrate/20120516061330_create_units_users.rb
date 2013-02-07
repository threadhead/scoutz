class CreateOrganizationsUsers < ActiveRecord::Migration
  def change
    create_table :organizations_users do |t|
      t.references :organization
      t.references :user
    end
    add_index :organizations_users, [:organization_id, :user_id]
    add_index :organizations_users, [:user_id, :organization_id]
  end
end
