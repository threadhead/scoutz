class CreateUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    add_index :user_relationships, [:parent_id, :child_id]
    add_index :user_relationships, [:child_id, :parent_id]
  end
end
