class CreateEventSignups < ActiveRecord::Migration
  def change
    create_table :event_signups do |t|
      t.references :event
      t.references :scout
      t.integer :scouts_attending, default: 0
      t.integer :adults_attending, default: 0
      t.integer :siblings_attending, default: 0
      t.text :comment
      t.datetime :canceled_at, default: nil

      t.timestamps
    end
    add_index :event_signups, :event_id
    add_index :event_signups, :scouts_attending
    add_index :event_signups, :adults_attending
    add_index :event_signups, :siblings_attending
  end
end
