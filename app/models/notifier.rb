class Notifier < ActiveRecord::Base
	belongs_to :user
  attr_accessible :account, :kind

  validates_presence_of :account
  validates_presence_of :kind
end
