class CreateUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships, id: false do |t|
      t.references :adult
      t.references :scout
    end
    add_index :user_relationships, [:adult_id, :scout_id]
    add_index :user_relationships, [:scout_id, :adult_id]
  end
end
