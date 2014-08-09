class ChangePagesDefaults < ActiveRecord::Migration
  def change
    change_column_default(:pages, :public, false)
    change_column_default(:pages, :front_page, false)
  end
end
