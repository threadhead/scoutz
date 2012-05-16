class Phone < ActiveRecord::Base
	belongs_to :user
  attr_accessible :kind, :number, :user_id
end
