class Organization < ActiveRecord::Base
	has_and_belongs_to_many :users
	
  attr_accessible :city, :state, :time_zone, :type, :unit_number
end
