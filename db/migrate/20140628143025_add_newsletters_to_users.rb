class AddNewslettersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weekly_newsletter_email, :boolean, default: true
    add_column :users, :monthly_newsletter_email, :boolean, default: true
  end
end
