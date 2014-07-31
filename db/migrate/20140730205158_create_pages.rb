class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.references :unit, index: true
      t.references :user, index: true
      t.boolean :public
      t.text :update_history

      t.timestamps
    end
    add_index :pages, :position
    add_index :pages, :public
  end
end
