class CreateUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    add_index :user_relationships, :parent_id
    add_index :user_relationships, :child_id
  end
end
