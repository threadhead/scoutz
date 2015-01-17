class Unit < ActiveRecord::Base
  mount_uploader :consent_form, ConsentFormUploader

  before_save :update_consent_form_attributes
  before_create :save_original_filename


  has_and_belongs_to_many :users
  # has_many :scouts, through: :users
  # has_many :adults, through: :users
  # has_many :scouts, through: :users, source: :scouts
  has_many :events, dependent: :destroy
  has_many :email_messages, dependent: :destroy
  has_many :sms_messages, dependent: :destroy
  has_many :health_forms, dependent: :destroy
  has_many :pages, -> { order(deactivated_at: :desc, position: :asc) }, dependent: :destroy
  has_many :pictures, class_name: 'Ckeditor::Picture', dependent: :destroy
  has_many :attachment_files, class_name: 'Ckeditor::AttachmentFile', dependent: :destroy

  has_many :sub_units, dependent: :destroy
  accepts_nested_attributes_for :sub_units, allow_destroy: true, reject_if: proc { |a| a["name"].blank? }


  validates :unit_type, :unit_number, :time_zone, :state, :city, presence: true
  validates :sl_uid, uniqueness: { allow_nil: true }


  validate :consent_form_size_validation, :if => "consent_form?"
  def consent_form_size_validation
    errors.add(:consent_form, "should be less than 1M") if consent_form.size > 1.0.megabytes.to_i
  end

  validates :consent_form_url, presence: true,  if: Proc.new {|u| u.attach_consent_form && u.use_consent_form == 2}
  validates :consent_form, presence: true, if: Proc.new {|u| u.attach_consent_form && u.use_consent_form == 3}



  # example: "Cub Scout Pack 134", "Boy Scout Troop 603"
  def name
    "#{unit_type.singularize} #{unit_type_title} #{unit_number}"
  end

  # example: "CS Pack 134", "BS Troop 603"
  def name_short
    "#{unit_type_short} #{unit_type_title} #{unit_number}"
  end

  # example: "Pack 134", "Troop 603"
  def name_unit
    "#{unit_type_title} #{unit_number}"
  end

  # example: "[CS Pack 134]", "[BS Troop 603]"
  def email_name
    "[#{unit_type_short} #{unit_type_title} #{unit_number}]"
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

  # example: :cub_scouts, :boy_scouts
  def unit_type_to_sym
    @unit_type_to_sym ||= unit_type.gsub(/ /, '').underscore.to_sym
  end

  # example: "CS", "BS"
  def unit_type_short
    @unit_type_short ||= AppConstants.unit_types[unit_type_to_sym][:short_name]
  end

  # example: "Pack", "Troop"
  def unit_type_title
    @unit_type_title ||= AppConstants.unit_types[unit_type_to_sym][:title]
  end

  # example: "Den", "Patrol"
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

  # def consent_form_url
  #   url = case use_consent_form
  #   when 1
  #     "http://www.scouting.org/filestore/pdf/19-673.pdf"
  #   when 2
  #     consent_form_url
  #   when 3
  #     return nil unless consent_form.present?
  #     Rails.configuration.action_mailer.asset_host + consent_form.url
  #   end
  # end




  def self.unit_types
    @@unit_types ||= AppConstants.unit_types.keys.map { |e| AppConstants.unit_types[e][:name] }
  end

  def self.unit_types_sub_units
    h = Hash.new
    # @@unit_types ||= AppConstants.unit_types.keys.each { |e| h[AppConstants.unit_types[e][:name]] = AppConstants.unit_types[e][:sub_unit_name] }
    AppConstants.unit_types.keys.each { |e| h[AppConstants.unit_types[e][:name]] = AppConstants.unit_types[e][:sub_unit_name] }
    h
    # SUB_UNIT_TYPES.keys
  end




  ## scopes
  def activities
    PublicActivity::Activity.where(unit_id: self.id).order('created_at DESC')
    # Unit.all
  end


  private
    def save_original_filename
      if use_consent_form.present?
        self.consent_form_original_file_name = consent_form.file.original_filename
      end
    end

    def update_consent_form_attributes
      if consent_form.present? && consent_form_changed?
        self.consent_form_updated_at = Time.zone.now
        self.consent_form_content_type = consent_form.file.content_type
        self.consent_form_file_size = consent_form.file.size
      end
    end

end
