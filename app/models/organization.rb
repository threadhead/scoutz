class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :sub_units, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :pictures, as: :assetable
  has_many :attachment_files, as: :assetable
  accepts_nested_attributes_for :sub_units, allow_destroy: true, reject_if: proc { |a| a["name"].blank? }

  attr_accessible :city, :state, :time_zone, :unit_type, :unit_number, :sub_units_attributes

  validates_presence_of :unit_type, :unit_number, :time_zone, :state, :city

  # validate :unique_sub_units
  # def unique_sub_units
  #   sub_units
  # end

  def name
    "#{unit_type.singularize} #{UNIT_TYPES[unit_type]} #{unit_number}"
  end

  def name_short
    "#{UNIT_TYPES_SHORT[unit_type]} #{UNIT_TYPES[unit_type]} #{unit_number}"
  end


  def event_kinds
    case unit_type
    when 'Cub Scouts'
      ['Pack Event', 'Den Event', 'Leader Event']
    when 'Boy Scouts'
      ['Troop Event', 'Patrol Event', 'Leader Event']
    when 'Venturing Crew'
      ['Crew Event', 'Leader Event']
    when 'Girl Scouts'
      ['Troop Event', 'Patrol Event', 'Leader Event']
    when 'Order of the Arrow'
      ['Lodge Event', 'Patrol Event', 'Leader Event']
    end
  end

  UNIT_TYPES = {
    'Cub Scouts' => 'Pack',
    'Boy Scouts' => 'Troop',
    'Venturing Crew' => 'Crew',
    'Girl Scouts' => 'Troop',
    'Order of the Arrow' => 'Troop'
  }

  UNIT_TYPES_SHORT = {
    'Cub Scouts' => 'CS',
    'Boy Scouts' => 'BS',
    'Venturing Crew' => 'VC',
    'Girl Scouts' => 'GS',
    'Order of the Arrow' => 'OA'
  }

  SUB_UNIT_TYPES = {
    'Cub Scouts' => 'Den',
    'Boy Scouts' => 'Patrol',
    'Venturing Crew' => 'Team',
    'Girl Scouts' => 'Patrol',
    'Order of the Arrow' => 'Patrol'
  }
    # 'Service Unit' => 'Unit',
    # 'Fire Service Explorer Post' => 'Post',
    # 'Sea Scout Ship' => 'Crew'

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
