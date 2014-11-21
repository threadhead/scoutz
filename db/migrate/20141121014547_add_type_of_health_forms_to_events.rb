class AddTypeOfHealthFormsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :type_of_health_forms, :integer, default: 0
  end
end
