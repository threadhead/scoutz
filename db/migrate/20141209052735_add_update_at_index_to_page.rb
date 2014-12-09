class AddUpdateAtIndexToPage < ActiveRecord::Migration
  def change
    add_index :pages, :updated_at
  end
end
