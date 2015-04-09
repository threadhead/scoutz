class CreateEmailGroups < ActiveRecord::Migration
  def change
    create_table :email_groups do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.text :users_ids, default: []
      t.boolean :private
      t.text :description

      t.timestamps null: false
    end
  end
end
