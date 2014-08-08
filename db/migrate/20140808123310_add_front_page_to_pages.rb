class AddFrontPageToPages < ActiveRecord::Migration
  def change
    add_column :pages, :front_page, :boolean
  end
end
