class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :unit_id
      t.string :kind
      t.string :name
      t.integer :user_id
      t.boolean :send_reminders, :default => true
      t.string :notifier_type
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :signup_required, :default => false
      t.datetime :signup_deadline
      t.string :location_name
      t.string :location_address1
      t.string :location_address2
      t.string :location_city
      t.string :location_state
      t.string :location_zip_code
      t.string :location_map_url
      t.string :attire
      t.text :message
      t.text :fees

      t.timestamps
    end

    add_index :events, :unit_id
    add_index :events, :user_id
    add_index :events, :start_at
    add_index :events, :end_at
    add_index :events, :signup_required
    add_index :events, :signup_deadline

  end
end
