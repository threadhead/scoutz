class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.integer :user_id
      t.integer :unit_id
      t.text :message
      t.string :subject
      t.datetime :sent_at
      t.boolean :send_to_unit, default: true
      t.boolean :send_to_sub_units, default: false
      t.string :sub_unit_ids, default: []

      t.timestamps
    end
    add_index :email_messages, :user_id
    add_index :email_messages, :unit_id
    add_index :email_messages, :sent_at
  end
end
