class Notifier < ActiveRecord::Base
	belongs_to :user
  attr_accessible :account, :kind, :user_id
end
