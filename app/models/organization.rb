class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :sub_units, dependent: :destroy
  accepts_nested_attributes_for :sub_units, allow_destroy: true, reject_if: proc { |a| a["name"].blank? }

  attr_accessible :city, :state, :time_zone, :unit_type, :unit_number, :sub_units_attributes

  validates_presence_of :unit_type, :unit_number, :time_zone, :state, :city

  # validate :unique_sub_units
  # def unique_sub_units
  #   sub_units
  # end


  SUB_UNIT_TYPES = {
    'Cub Scouts' => 'Den',
    'Boy Scouts' => 'Patrol',
    'Venturing Crew' => 'Crew',
    'Girl Scouts' => 'Patrol',
    'Service Unit' => 'Unit',
    'Fire Service Explorer Post' => 'Post',
    'Order of the Arrow' => 'Order',
    'Sea Scout Ship' => 'Crew'
  }

  def self.unit_types
    SUB_UNIT_TYPES.keys
  end

  def self.sub_unit_type(organization_type)
    SUB_UNIT_TYPES[organization_type.to_s]
  end

  def sub_unit_type
    SUB_UNIT_TYPES[unit_type]
  end
end
