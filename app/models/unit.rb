class Unit < ActiveRecord::Base
  has_and_belongs_to_many :users
  # has_many :scouts, through: :users
  # has_many :adults, through: :users
  # has_many :scouts, through: :users, source: :scouts
  has_many :sub_units, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :email_messages, dependent: :destroy
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
    "#{unit_type.singularize} #{unit_type_title} #{unit_number}"
  end

  def name_short
    "#{unit_type_short} #{unit_type_title} #{unit_number}"
  end

  def name_unit
    "#{unit_type_title} #{unit_number}"
  end

  def scouts
    self.users.where(type: 'Scout')
  end

  def adults
    self.users.where(type: 'Adult')
  end

  def scout_rank_count
    @scout_rank_count ||= self.scouts.group(:rank).count
  end

  def scout_sub_unit_count
    @scout_sub_unit_count ||= self.scouts.joins(:sub_unit).group('"sub_units"."name"').count
  end

  def unit_type_to_sym
    @unit_type_to_sym ||= unit_type.gsub(/ /, '').underscore.to_sym
  end

  def unit_type_short
    @unit_type_short ||= AppConstants.unit_types[unit_type_to_sym][:short_name]
  end

  def unit_type_title
    @unit_type_title ||= AppConstants.unit_types[unit_type_to_sym][:title]
  end

  def sub_unit_name
    @sub_unit_name ||= AppConstants.unit_types[unit_type_to_sym][:sub_unit_name]
  end

  def ranks
    @ranks ||= AppConstants.unit_types[unit_type_to_sym][:ranks]
  end

  def scout_leadership_positions
    @scout_leadership_positions ||= AppConstants.unit_types[unit_type_to_sym][:scout_leadership_positions]
  end

  def adult_leadership_positions
    @adult_leadership_positions ||= AppConstants.unit_types[unit_type_to_sym][:adult_leadership_positions]
  end

  def event_kinds
    AppConstants.unit_types[unit_type_to_sym][:event_types]
  end

  def self.unit_types
    @@unit_types ||= AppConstants.unit_types.keys.map { |e| AppConstants.unit_types[e][:name] }
    # SUB_UNIT_TYPES.keys
  end


  ## scopes
  def activities
    PublicActivity::Activity.where(unit_id: self.id).order('created_at DESC')
  end
end
