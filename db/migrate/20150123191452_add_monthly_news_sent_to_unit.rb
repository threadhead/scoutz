class AddMonthlyNewsSentToUnit < ActiveRecord::Migration
  def change
    add_column :units, :monthly_newsletter_sent_at, :datetime
    add_column :units, :weekly_newsletter_sent_at, :datetime
  end
end
