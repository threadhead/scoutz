class Organization < ActiveRecord::Base
	has_and_belongs_to_many :users
	
  attr_accessible :city, :state, :time_zone, :unit_type, :unit_number

  validates_presence_of :unit_type, :unit_number, :time_zone, :state, :city

end
