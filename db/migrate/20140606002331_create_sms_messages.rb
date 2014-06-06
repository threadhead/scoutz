class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.references :user, index: true
      t.references :unit, index: true
      t.text :message
      t.datetime :sent_at
      t.string :sub_unit_ids #, default: "--- []\n"
      t.integer :send_to_option, default: 1

      t.timestamps
    end
  end
end
