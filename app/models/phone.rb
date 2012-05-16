class Phone < ActiveRecord::Base
  belongs_to :user
  attr_accessible :kind, :number

  validates_presence_of :kind
  validates_presence_of :number
end
