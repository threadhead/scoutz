class CreateNotifiers < ActiveRecord::Migration
  def change
    create_table :notifiers do |t|
      t.integer :user_id
      t.string :kind
      t.string :account

      t.timestamps
    end

    add_index :notifiers, :user_id
  end
end
