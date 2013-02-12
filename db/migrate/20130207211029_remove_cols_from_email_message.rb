class RemoveColsFromEmailMessage < ActiveRecord::Migration
  def up
    remove_column :email_messages, :send_to_unit
    remove_column :email_messages, :send_to_sub_units
  end

  def down
    add_column :email_messages, :send_to_unit, :boolean, default: true
    add_column :email_messages, :send_to_sub_units, :boolean, default: false
  end

end
